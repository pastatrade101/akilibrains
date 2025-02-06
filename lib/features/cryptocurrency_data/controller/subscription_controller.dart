import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../data/repositories/authentication/authentication_repository.dart';

class SubscriptionController extends GetxController {
  final CollectionReference _subscribersCollection =
  FirebaseFirestore.instance.collection('subscribers');
  final userId = AuthenticationRepository.instance.getUserID;
  final RxBool isSubscribed = false.obs;

  @override
  Future<void> onInit() async {

    isSubscribed.value = await isSubscriber(userId);
    super.onInit();

  }

  Future<bool> isSubscriber(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _subscribersCollection
          .where('id', isEqualTo: userId)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking subscriber status: $e');
      return false;
    }
  }
}
