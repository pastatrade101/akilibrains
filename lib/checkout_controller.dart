import 'dart:ffi';


import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:trade101/utils/constants/image_strings.dart';
import 'package:trade101/utils/constants/sizes.dart';
import 'package:trade101/utils/loader/full_screen_loader.dart';
import 'package:trade101/utils/network/network_connectivity_check.dart';

import 'azampay_api.dart';
import 'common/widgets/list_tiles/payment_list_tile.dart';
import 'common/widgets/texts/section_heading.dart';
import 'features/library/models/payment_method_model.dart';

class CheckoutController extends GetxController {
  static CheckoutController get instance => Get.find();
  final RxBool isLoading = false.obs;
  final RxBool isValid = false.obs;
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final Rx<PaymentMethodModel> selectedPaymentMethod = PaymentMethodModel.empty().obs;
  final Rx<String> payOption = ''.obs;
  GlobalKey<FormState> checkOutFormKey = GlobalKey<FormState>();


  @override
  void onInit() {
    selectedPaymentMethod.value = PaymentMethodModel(name: 'Mpesa', image: TImages.vodacom);
    super.onInit();
  }


  Future<dynamic> selectPaymentMethod(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (_) => SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(TSizes.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TSectionHeading(title: 'Select Payment Method', showActionButton: false),
              const SizedBox(height: TSizes.spaceBtwSections),
              TPaymentTile(paymentMethod: PaymentMethodModel(name: 'M-PESA', image: TImages.vodacom)),
               const SizedBox(height: TSizes.spaceBtwItems/2),
              TPaymentTile(paymentMethod: PaymentMethodModel(name: 'Mixx by Yas', image: TImages.tigopesa)),
              const SizedBox(height: TSizes.spaceBtwItems/2),
              TPaymentTile(paymentMethod: PaymentMethodModel(name: 'Airtel', image: TImages.airtel)),  const SizedBox(height: TSizes.spaceBtwItems/2),
              TPaymentTile(paymentMethod: PaymentMethodModel(name: 'Halopesa', image: TImages.halopesa)),

              const SizedBox(height: TSizes.spaceBtwItems/2),
              const SizedBox(height: TSizes.spaceBtwSections),
            ],
          ),
        ),
      ),
    );
  }


  Future<bool> checkOut() async {
    try {
      // Start loading

      //   Check internet connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        return false;
      }
      //   form validation
      if (!checkOutFormKey.currentState!.validate()) {
        return false;
      }
      //   Policy agreement

      TFullScreenLoader.openLoadingDialog(
          'We are processing your information', TImages.loader);
return true;





      //   move to the verify email screen

    } catch (e) {
      //     Remove loader
return false;

    }
  }

  bool checkInternetConnection() {
    // Perform internet connection check
    // Return true if connected, false otherwise
    return true; // Placeholder, replace with actual logic
  }

  bool registerUserInFirebase() {
    // Perform user registration in Firebase
    // Return true if successful, false otherwise
    return true; // Placeholder, replace with actual logic
  }

  void saveAuthenticatedUserData() {
    // Save authenticated user data
  }


  Future<void> handleCheckout(String price) async {
    final String phoneNumber = phoneNumberController.text;
    final double amount = double.parse(price);

    // Call the function to handle checkout
    await _handleCheckout(phoneNumber, amount,await generateAccessToken());
  }

   updateSelect(Set<String> newSelection){payOption.value = newSelection as String;}

  Future<void> _handleCheckout(String phoneNumber, double amount, jwtToken) async {
    // Define the checkout API endpoint
     String apiUrl  =  'https://sandbox.azampay.co.tz/azampay/mno/checkout';

    // Prepare request data
    final Map<String, dynamic> requestData = {
      'accountNumber': phoneNumber, // Replace 'string' with actual account number
      'additionalProperties': {
        'property1': null,
        'property2': null,
      },
      'amount': amount.toString(),
      'currency': 'TZS', // Replace 'string' with actual currency
      'externalId': '656T78Y8YT8T789I09UYYTY', // Replace 'string' with actual external ID
      'provider': 'Airtel',
    };

    // Prepare headers
    final Map<String, String> headers =  {
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

}

