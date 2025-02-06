import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String?> generateAccessToken() async {
  final url = Uri.parse('https://authenticator-sandbox.azampay.co.tz/AppRegistration/GenerateToken');

  final Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  final Map<String, String> requestBody = {
    "appName": "rabit-store",
    "clientId": "0f23b7d2-a905-463b-b0d7-253dabb9a3a4",
    "clientSecret": "JUMehT10/gmzH4OG/vNBFME0UzXq9hC6yQ0s0AbzLOg+3Ga6qmfl5iAyfdiPKIapbLiIRu6LuhAgE3gmPJcfsoilDFo6zM6GOYdTrUNg/1w5FuiQGNxugwJ2ZoGJ5bjE2vfrf5S8mpuu6sj3QNh24pjq3b7dZjM/VXp7xuJsmHY7NnvU4WZSMdzbbxjfXFs3xecSnEVznFryuKEbUP0d+fpK/uaeHESfAbOXTt8jFQu1kEKHsskxDFAP5pk/s47kKIOUGboHRbGAhN4XM4gG+XNyX6BVo6MrFSvCNyro0g6ymtJbsq+FdUidnPLPSMYVXmCsJFdk6NIitgskFGda6t/ynDuVzHbc9Amcvl4eGtCzJLC4MjjlaGdZqvji4VEeUt65ihf8+r/gb3OyuD1k+nDI0S6zGhNG+j/aNL8SiHi9/f74tI5UcgucRMsmmStoPyjMyUJrj3USIBUS8VgTUWKscTUKdzRY6me96+U1CKEbLxcErV6gma1SOIMdBFkZ/0k7w81b3xiS3vNpcjyhItR0qU5Sz1MRG0Iv4goH8N18PiTP4tBdF/4i2zo2VuJBay9xIbUfwjiZNn+vdAqMPL22RT1K3wA9v42uJRvkvA7NqPUKRYd+vUFf6fyUX59K2XZMxaGaqfBwDuqI7frbw8Efs3VMMrZWwUQpK4Y9cEw="};

  try {
    final response = await http.post(
      url,
      headers: headers,
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final String accessToken = responseData['data']['accessToken'];
      if (kDebugMode) {
        print(accessToken);


      }
      return accessToken;
    } else {
      final responseData = json.decode(response.body);
      final errorMessage = responseData['message'];
      return errorMessage;
    }
  } catch (e) {
    // Return the error message if an exception occurs
    return e.toString();
  }
}


Future<void> handleCheckout(String phoneNumber, double amount, String jwtToken) async {
  // Define the checkout API endpoint
  final String apiUrl = 'https://sandbox.azampay.co.tz/azampay/mno/checkout';

  // Prepare request data
  final Map<String, dynamic> requestData = {
    'phone_number': phoneNumber,
    'amount': amount.toString(),
  };

  // Prepare headers
  final Map<String, String> headers = {
    'Authorization': 'Bearer $jwtToken',
    'Content-Type': 'application/json',
  };

  try {
    // Send POST request
    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: jsonEncode(requestData),
    );

    // Check status code
    if (response.statusCode == 200) {
      // Parse JSON response
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      // Check if payment was successful
      if (responseData['success'] == true) {
        // Payment successful, handle further actions
        print('Payment successful');
      } else {
        // Payment failed, handle accordingly
        print('Payment failed: ${responseData['message']}');
      }
    } else {
      // Request failed, handle accordingly
      print('Error1: ${response.reasonPhrase}');
    }
  } catch (e) {
    // Handle exceptions
    print('Exception occurred: $e');
  }
}

