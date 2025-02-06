
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trade101/features/cryptocurrency_data/controller/subscription_controller.dart';
import 'package:trade101/features/cryptocurrency_data/screens/global_cryptocurrency_data.dart';
import 'package:trade101/home_menu.dart';
import 'package:trade101/utils/loader/loader.dart';

class SubscriberController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SubscriptionController subscriptionController = Get.put(SubscriptionController());

  Future<void> addSubscriber(String uid, String phoneNumber, String email) async {
    try {
      await _firestore.collection('subscribers').doc(uid).set({
        'id': uid,
        'email': email,
        'phone': phoneNumber,
        // You can add more fields as needed
      });

      TLoaders.successSnackBar(title:  'You have been subscribed Now visit the analytics page to view indicators.',message: 'Successfully Subscribed');
      Get.offAll(const HomeMenu());
    } catch (error) {
      Get.snackbar('Error', 'Failed to add subscriber: $error');
    }
  }
}