import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/repositories/authentication/authentication_repository.dart';

import '../../../../home_menu.dart';

import '../../../../utils/constants/image_strings.dart';

import '../../../checkout_controller.dart';
import '../../../common/widgets/success_screen/success_screen.dart';
import '../../../data/repositories/user/orders/order_repository.dart';
import '../../../utils/loader/full_screen_loader.dart';
import '../../../utils/loader/loader.dart';
import '../models/order_model.dart';

class OrderController extends GetxController {
  static OrderController get instance => Get.find();
  final controller = CheckoutController.instance;

  /// Variables

  final checkoutController = CheckoutController.instance;
  final orderRepository = Get.put(OrderRepository());

  /// Fetch user's order history
  Future<List<OrderModel>> fetchUserOrders() async {
    final userId = AuthenticationRepository.instance.getUserID;


    try {
      final userOrders = await orderRepository.fetchUserOrders(userId);
      return userOrders;
    } catch (e) {
      TLoaders.warningSnackBar(title: 'Oh Snap!', message: e.toString());
      return [];
    }
  }

  /// Add methods for order processing

  Future<void> processOrder(
      amount, phoneNumber, jwtToken, azamToken, bookID) async {

    final userId = AuthenticationRepository.instance.getUserID;
    // Define the checkout API endpoint
    TFullScreenLoader.openLoadingDialog(
        'Processing your order', TImages.orderProcessing);
    String apiUrl = 'https://us-central1-rabit-store.cloudfunctions.net/processOrder';

    // Prepare request data

    final String id = UniqueKey().toString();
    final String cleanId = id.substring(1, id.length - 1);

    final Map<String, dynamic> requestData = {
      // account number
      'accountNumber': phoneNumber,
      'azamToken': azamToken,
      'jwtToken': jwtToken,
      'additionalProperties': {
        //User ID
        'property1': userId,
        //BookID
        'property2': bookID,
        'source': 'pastory',
      },
      // Amount in TZS
      'amount': amount,
      // Currency
      'currency': 'TZS',
      // Random Generated keys from the app
      'externalId': cleanId,
      // Provider name
      'provider': controller.selectedPaymentMethod.value.name,
    };
    // print('response data: $requestData');
    // print('This is the books ids: $bookID');

    // print('This is the User Token: $azamToken');
    // Prepare headers
    final Map<String, String> headers = {
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': 'application/json',
    };



    try {
      // Get user authentication Id
      final userId = AuthenticationRepository.instance.getUserID;
      if (userId.isEmpty) return;

      // Send POST request
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(requestData),
      );
      // final userId = await AuthenticationRepository.instance.getUserID;
      // if (userId.isEmpty) return;

      // final order = OrderModel(
      //   // Generate a unique ID for the order
      //   id: id,
      //   userId: userId,
      //   status: OrderStatus.pending,
      //   totalAmount: amount,
      //   orderDate: DateTime.now(),
      //   paymentMethod: checkoutController.selectedPaymentMethod.value.name, phoneNumber: phoneNumber,
      //
      //   // Set Date as needed
      //
      //
      // );
      // Check status code
      if (response.statusCode == 200) {
        // Save the order to Firestore

        // Parse JSON response
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print('Response data: $responseData');


        // Check if payment was successful
        if (responseData['success'] == true) {
          print('response data: $responseData');
         TLoaders.successSnackBar(title: 'The payment request has been sent successfully. you will be prompted to pay!',message: 'Congratulations!');


          Get.offAll(() => SuccessScreen(
                image: TImages.paymentSuccess,
                title: 'Payment On Progress!',
                subTitle:
                    'Your Payment will be finalized soon and the book will be available in My Book Menu once payment complete',
                onPressed: () => Get.offAll(() => const HomeMenu()),
              ));
          // Payment successful, handle further actions
          print('Payment successful: ${responseData['message']}');
          print(
              'Response: ${response.statusCode} + Phone: $phoneNumber Amount $amount + MNO: ${controller.selectedPaymentMethod.value.name} ID: $id');
        } else {
          // Payment failed, handle accordingly
          print('Payment failed: ${responseData['message']}');
          TLoaders.warningSnackBar(title: 'The payment request has been failed. Please try again!',message: 'Oh Snap!');
        }
      } else {
        // Request failed, handle accordingly
        print('Error: ${response.statusCode} + $phoneNumber ' +
            '$amount +${controller.selectedPaymentMethod.value.name}');
      }
    } catch (e) {
      // Handle exceptions
      print('Exception occurred: $e');
    }
  }
}
