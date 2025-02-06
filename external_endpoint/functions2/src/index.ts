import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import axios from "axios";

// Initialize Firebase Admin SDK
admin.initializeApp();

// Cloud Function to process orders
export const processOrder = functions.https.onRequest(async (req, res) => {
  try {
    // Retrieve parameters from the request
    const {amount, phoneNumber, jwtToken, bookID} = req.body;

    // Retrieve user ID from Firebase Authentication
    const userId = req.user.uid; // Assuming you're using Firebase Authentication

    // Define API endpoint
    const apiUrl = "https://creatorstore.store/api/pastory/azampay/request/payment";

    // Prepare request data
    const requestData = {
      accountNumber: phoneNumber,
      additionalProperties: {
        property1: userId,
        property2: bookID,
        source: "pastory",
      },
      amount,
      currency: "TZS",
      externalId: Math.random().toString(36).substring(2, 15), // Generate unique external ID
      provider: "SomeProvider", // Replace with your payment provider
    };

    // Prepare headers
    const headers = {
      "Authorization": `Bearer ${jwtToken}`,
      "Content-Type": "application/json",
    };

    // Send POST request
    const response = await axios.post(apiUrl, requestData, {headers});

    // Check response status
    if (response.status === 200) {
      // Parse JSON response
      const responseData = response.data;

      // Check if payment was successful
      if (responseData.success) {
        // Save order to Firestore or any database
        // Your logic here

        // Return success response
        return res.status(200).json({success: true, message: "Order processed successfully"});
      } else {
        // Return failure response
        return res.status(400).json({success: false, message: "Payment failed"});
      }
    } else {
      // Return failure response
      return res.status(response.status).json({success: false, message: "Request failed"});
    }
  } catch (error) {
    // Handle errors
    console.error("Error processing order:", error);
    return res.status(500).json({success: false, message: "Internal server error"});
  }
});
