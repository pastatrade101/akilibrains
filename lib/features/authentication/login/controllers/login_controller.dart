
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/loader/full_screen_loader.dart';
import '../../../../utils/loader/loader.dart';
import '../../../../utils/network/network_connectivity_check.dart';
import '../../personalization/controllers/user_controller.dart';

class LoginController extends GetxController {
//   Variables
  final rememberMe = false.obs;
  final hidePassword = true.obs;
  final localStorage = GetStorage();
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final userController = Get.put(UserController());

  @override
  void onInit() {
    // email.text = localStorage.read('REMEMBER_ME_EMAIL');
    // password.text = localStorage.read('REMEMBER_ME_PASSWORD');

  }


// [EmailAuthentication] Login
  Future<void> emailAndPasswordSignIn() async {
    try {
//       Start Loading

      // Check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {TFullScreenLoader.stopLoading();
        return;
      }
// Form validation

      if (!loginFormKey.currentState!.validate()) {
        return;
      }

      // Save data if remember me is selected
      if (rememberMe.value) {
        // Check if values are already stored
        if (localStorage.read('REMEMBER_ME_EMAIL') != email!.text.trim()) {
          localStorage.write('REMEMBER_ME_EMAIL', email!.text.trim());
        }
        if (localStorage.read('REMEMBER_ME_PASSWORD') != password.text.trim()) {
          localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
        }
      }

      TFullScreenLoader.openLoadingDialog('Loggin you in', TImages.animation);
      // Login user using email and password
      final userCredentials = await AuthenticationRepository.instance.loginWithEmailAndPassword(email.text.trim(), password.text.trim());

    //   Remove loading screen
      TFullScreenLoader.stopLoading();
      TLoaders.successSnackBar(title: 'Congratulations! You have successfully logged in!',message: 'Successfully Logged in');

    //   Redirect
      await AuthenticationRepository.instance.screenRedirect(userCredentials.user);
    }catch(e){
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: e.toString() ,message: 'Oh Snap');
    }
  }
  Future<void> googleSignIn() async {
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialog('Logging you in...', TImages.loader);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Google Authentication
      final userCredentials = await AuthenticationRepository.instance.signInWithGoogle();

      // Save Authenticated user data in the Firebase Firestore
      await userController.saveUserRecord(userCredentials: userCredentials);

      // Remove Loader
      TFullScreenLoader.stopLoading();

      // Redirect
      await AuthenticationRepository.instance.screenRedirect(userCredentials?.user);
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }


}