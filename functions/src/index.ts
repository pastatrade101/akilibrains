import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import axios from "axios";
import {Request, Response} from "express";
import * as nodemailer from "nodemailer";


admin.initializeApp();

const db = admin.firestore();
/**
 * Handle AzamPay HTTP request.
 *
 * This function processes AzamPay payment notifications. It saves successful orders to the Users_Order collection
 * and sends notification emails to users in case of failed payments.
 */


export const azamPay = functions.https.onRequest(async (request, response) => {
  try {
    // Print request body in the console
    console.log("This is the result: " + JSON.stringify(request.body));

    // Extract data from the request body
    const {transactionstatus, transid, utilityref, mnoreference, msisdn, amount, additionalProperties} = request.body;

    // Extract userId and other properties from additionalProperties
    const externalId = utilityref;
    const {property1: userId, property2: bookID} = additionalProperties;
    console.log("ADDITIONAL PROPERTIES: " + bookID);

    // Check if the transaction was successful
    if (transactionstatus === "success") {
      const orderDataArray = [];

      let idsArray = []; // Initialize idsArray

      // Check if bookID is an array
      if (bookID.startsWith("[") && bookID.endsWith("]")) {
        // Parse bookID as JSON array
        idsArray = bookID.substring(1, bookID.length - 1).split(", "); // This will throw an error if bookID is not a valid JSON array
      } else {
        // If bookID is not an array, treat it as a single ID
        idsArray.push(bookID);
      }

      // Loop through each bookID
      for (const id of idsArray) {
        const orderData = {
          userId,
          bookID: id, // Use the current book ID in the loop
          amount,
          msisdn,
          transid,
          mnoreference,
          transactionstatus,
          externalId,
          createdAt: admin.firestore.FieldValue.serverTimestamp(), // Add a timestamp for when the order was created
        };
        orderDataArray.push(orderData); // Add order data to the array
      }

      // Add the order(s) to the Users_Order collection
      await Promise.all(orderDataArray.map((orderData) => db.collection("Users_Order").add(orderData)));

      response.status(200).send("Order(s) created successfully.");
    } else {
      // If payment was not successful (400 status), save the order in the failed_order collection
      await db.collection("failed_order").add({
        userId,
        bookID,
        amount,
        msisdn,
        transid,
        mnoreference,
        transactionstatus,
        externalId,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      response.status(400).send("Payment was not successful.");
    }
  } catch (error) {
    console.error("Error creating order:", error);
    response.status(500).send("Error creating order.");
  }
});


export const processOrder = functions.https.onRequest(async (req: Request, res: Response) => {
  try {
    // Retrieve parameters from the request
    const {amount, externalId, provider, accountNumber, jwtToken, azamToken, additionalProperties} = req.body;
    const {property2: bookID} = additionalProperties;
    console.log("Request Data:", req.body);


    // Verify user authentication
    const user = await admin.auth().verifyIdToken(jwtToken);
    const userId = user.uid;
    console.log("Book ID: "+bookID);
    console.log("Book ID: "+accountNumber);
    // Define API endpoint
    const apiUrl = "https://creatorstores.xyz/api/pastory/azampay/request/payment";
    console.log("Book ID: "+bookID);
    console.log("Book ID: "+accountNumber);
    // Prepare request data

    const requestData =

    {
      "accountNumber": accountNumber,
      "additionalProperties": {
        "property1": userId,
        "property2": bookID,
        "source": "pastory",
      },
      "amount": amount,
      "currency": "TZS",
      "externalId": externalId,
      "provider": provider,
    };


    console.log("---------Checkout Data:-------", requestData);

    // Prepare headers
    const headers = {
      "Authorization": `Bearer ${azamToken}`,
      "Content-Type": "application/json",
    };

    // Send POST request
    const response = await axios.post(apiUrl, requestData, {headers},);
    await console.log("..........Response Data:-------", response.data);
    console.log("..........Response Status:-------", response.status);
    console.log("..........Phone:-------", response.data.phoneNumber);

    // Check response status
    if (response.status === 200) {
      // Parse JSON response
      const responseData = response.data;

      // Check if payment was successful
      if (responseData.success) {
        // Save order to Firestore or any database
        // Your logic here

        // Return success response
        res.status(200).json({success: true, message: "Order processed successfully"});
      } else {
        // Return failure response
        res.status(400).json({success: false, message: "Payment failed"});
      }
    } else {
      // Return failure response
      res.status(response.status).json({success: false, message: "Request failed"});
    }
  } catch (error) {
    // Handle errors
    console.error("Error processing order:", error);
    res.status(500).json({success: false, message: "Internal server error"});
  }
});

// Function to retrieve most sold books
export const mostBookSold = functions.https.onRequest(async (request, response) => {
  try {
    // Get all orders
    const ordersSnapshot = await db.collection("Users_Order").get();

    // Extract book IDs and their counts from orders
    const booksCount: { [key: string]: number } = {};
    ordersSnapshot.forEach((order) => {
      const bookID = order.data().bookID;
      booksCount[bookID] = (booksCount[bookID] || 0) + 1;
    });

    // Convert booksCount to an array of objects
    const booksArray = Object.keys(booksCount).map((key) => ({
      bookID: key,
      count: booksCount[key],
    }));

    // Sort the array based on the count in descending order
    booksArray.sort((a, b) => b.count - a.count);

    // Get the top 5 most sold books
    const mostSoldBooks = booksArray.slice(0, 7);

    // Fetch book details for the most sold books from the Books collection
    const booksPromises = mostSoldBooks.map(async (book) => {
      const bookSnapshot = await db.collection("books").doc(book.bookID).get();
      // Include additional book details in the response
      return {id: book.bookID, count: book.count, ...bookSnapshot.data()};
    });

    // Wait for all book details to be fetched
    const mostSoldBooksData = await Promise.all(booksPromises);

    // Log the result to the console
    console.log("Most Sold Books:", mostSoldBooksData);

    // Send the response with the formatted data
    response.status(200).json(mostSoldBooksData);
  } catch (error) {
    console.error("Error retrieving most sold books:", error);
    response.status(500).send("Error retrieving most sold books.");
  }
});

// Cloud Function to send email notification upon new User_Order created
export const sendEmailOnOrderCreated = functions.firestore
  .document("Users_Order/{orderId}")
  .onCreate(async (snapshot, context) => {
    try {
      const orderId = context.params.orderId;
      const orderData = snapshot.data();

      // Extract relevant data from the order
      const bookId = orderData.bookID;
      const amount = orderData.amount;
      console.log("This is amount and BookID:", orderData);

      // Fetch book details
      const bookSnapshot = await admin.firestore().doc(`books/${bookId}`).get();
      const bookData = bookSnapshot.data();
      const bookName = bookData?.BookName || "Unknown Book";
      console.log("This is a book data:", bookData);

      // Extract author name from book details
      const authorName = bookData?.Author || "Unknown Author";
      console.log("This is a book data:", bookData);

      let authorEmail = ""; // Declare authorEmail variable

      // Fetch author details
      const authorsSnapshot = await admin.firestore().collection("authors").where("authorName", "==", authorName).get();
      if (!authorsSnapshot.empty) {
        // Check if any documents were returned
        const authorData = authorsSnapshot.docs[0].data();
        authorEmail = authorData?.email || ""; // Set authorEmail value
      } else {
        console.log("No matching author found for name:", authorName);
        // Handle the case where no matching author is found
      }

      // Send email notification if author email is available
      if (authorEmail) {
        await sendEmail(authorEmail, `New Order for Your Book - Order ID: ${orderId}`, `A new order has been created for your book "${bookName}".\n\nAmount: ${amount}`);
        console.log("Email notification sent successfully.");
      } else {
        console.log("Author email not found. No notification sent.");
      }
    } catch (error) {
      console.error("Error sending email notification:", error);
    }
  });

/**
 * Sends an email using nodemailer.
 * @param {string} recipientEmail - The email address of the recipient.
 * @param {string} subject - The subject of the email.
 * @param {string} body - The body content of the email.
 */
async function sendEmail(recipientEmail: string, subject: string, body: string) {
  const transporter = nodemailer.createTransport({
    service: "gmail",
    auth: {
      user: "pastatrade101@gmail.com",
      pass: "uojn wayl ayxl nqdk",
    },
  });

  const mailOptions = {
    from: "pastatrade101@gmail.com",
    to: recipientEmail,
    subject: subject,
    text: body,
  };

  await transporter.sendMail(mailOptions);
}

