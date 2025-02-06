import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';


import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/loader/full_screen_loader.dart';
import '../../../../utils/loader/loader.dart';
import '../../../../utils/network/network_connectivity_check.dart';
import '../../password_configuration/reset_password.dart';

class ForgetPasswordController extends GetxController{
  static ForgetPasswordController get instance => Get.find();


  final email=TextEditingController();
  GlobalKey<FormState> forgetPasswordFormKey =GlobalKey<FormState>();
//   Send reset password
sendPasswordResetEmail()async{
  try{
    TFullScreenLoader.openLoadingDialog('Sending Password',TImages.animation);
    // Check internet connectivity
    final isConnected = await NetworkManager.instance.isConnected();
    if (!isConnected) {
      return;
    }

    // Form validation

    if (!forgetPasswordFormKey.currentState!.validate()) {
      TFullScreenLoader.stopLoading();
      return;
    }
    // Send email to reset password
    await AuthenticationRepository.instance.sendPasswordResetEmail(email.text.trim());
    // Removing loader
    TFullScreenLoader.stopLoading();
  //   Show success message
    TLoaders.successSnackBar(title: 'Email link sent to reset your password'.tr,message: 'Email Sent');
  //   Redirect

    Get.to(()=> ResetPassword(email: email.text.trim(),));
  }catch(e){
    // Removing loader
    TFullScreenLoader.stopLoading();
    TLoaders.errorSnackBar(title: e.toString(),message: 'Oh Snap');
  }
}
resendPasswordResetEmail(String email)async{


  try{
    TFullScreenLoader.openLoadingDialog('Resending Password',TImages.animation);
    // Check internet connectivity
    final isConnected = await NetworkManager.instance.isConnected();
    if (!isConnected) {
      return;
    }

    // Form validation


    // Send email to reset password
    await AuthenticationRepository.instance.sendPasswordResetEmail(email);
    // Removing loader
    TFullScreenLoader.stopLoading();
    //   Show success message
    TLoaders.successSnackBar(title: 'Email link sent to reset your password'.tr,message: 'Email Sent');
    //   Redirect


  }catch(e){
    // Removing loader
    TFullScreenLoader.stopLoading();
    TLoaders.errorSnackBar(title: e.toString(),message: 'Oh Snap');
  }
}
}