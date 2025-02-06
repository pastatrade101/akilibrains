import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';


import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../data/repositories/user/user_repository.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/loader/full_screen_loader.dart';
import '../../../../utils/loader/loader.dart';
import '../../../../utils/network/network_connectivity_check.dart';
import '../../../library/models/user_model.dart';
import '../screens/verify_email.dart';


class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  final hidePassword = true.obs;
  final policyCheck = false.obs;

// TextEditingController instances
  final phoneNumber = TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final userName = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();

  void signUp() async {
    try {
      // Start loading

      //   Check internet connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        return;
      }
      //   form validation
      if (!signUpFormKey.currentState!.validate()) {
        return;
      }
      //   Policy agreement
      if (!policyCheck.value) {
        TLoaders.warningSnackBar(
            title: 'Accept privacy policy',
            message:
                'In order to create account you must have to read and accept Privacy Policy and terms of use');
        return;
      }
      TFullScreenLoader.openLoadingDialog(
          'We are processing your information', TImages.loader);

      // Register user in the firebase
      final userCredential = await AuthenticationRepository.instance
          .registerWithEmailAndPassword(
              email.text.trim(), password.text.trim());

      //   save authenticated user data

      final newUser = UserModel(
          id: userCredential.user!.uid,
          firstName: firstName.text.trim(),
          lastName: lastName.text.trim(),
          userName: userName.text.trim(),
          email: email.text.trim(),
          phoneNumber: phoneNumber.text.trim(),
          profilePicture: '');

      final userRepository = Get.put(UserRepository());
      await userRepository.saveUserRecord(newUser);
      TFullScreenLoader.stopLoading();
      //   Show success message
      TLoaders.successSnackBar(
          title: 'You have successfuly register the account please verify',
          message: 'Successfully Registered');

      //   move to the verify email screen
      Get.to( VerifyEmailScreen( email: email.text.trim(),));
    } catch (e) {
      //     Remove loader
      TFullScreenLoader.stopLoading();

      //   remove loader
      TFullScreenLoader.stopLoading();
    //   Show some generic error to the user
      TLoaders.errorSnackBar(title:'Oh Snap' ,message: e.toString());
    }
  }
}
