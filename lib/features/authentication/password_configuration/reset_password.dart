import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';


import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../controllers/forget_password/forget_password_controller.dart';
import '../login/screens/login.dart';

class ResetPassword extends StatelessWidget {
  static ForgetPasswordController get instance => Get.find();
  const ResetPassword({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Appbar to go back OR close all screens and Goto LoginScreen()
      appBar: TAppBar(
        actions: [
          IconButton(
              onPressed: () => Get.offAll(const LoginScreen()),
              icon: const Icon(CupertinoIcons.clear)),
        ],
        padding: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              /// Image with 60% of screen width
             Lottie.asset(TImages.resetEmail,width: THelperFunctions.screenWidth()*.6),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Title & SubTitle
              Text(TTexts.changeYourPasswordTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center),
              const SizedBox(height: TSizes.spaceBtwItems),
              Text(email,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: TSizes.spaceBtwItems),
              Text(
                TTexts.changeYourPasswordSubTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Buttons
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        Get.offAll(() => const LoginScreen());
                      },
                      child: const Text(TTexts.done))),
              const SizedBox(height: TSizes.spaceBtwItems),
              SizedBox(
                  width: double.infinity,
                  child: TextButton(
                      onPressed: () {ForgetPasswordController.instance.resendPasswordResetEmail(email);}, child: const Text(TTexts.resendEmail))),
            ],
          ),
        ),
      ),
    );
  }
}
