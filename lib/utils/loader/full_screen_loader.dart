import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../constants/colors.dart';
import 'package:lottie/lottie.dart';

import '../constants/image_strings.dart';
import '../constants/sizes.dart';
import '../helpers/helper_functions.dart';

class TFullScreenLoader {
  static void openLoadingDialog(String text, String animation) {
    showDialog(
      context: Get.overlayContext!,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: Container(
          color: THelperFunctions.isDarkMode(Get.context!)
              ? TColors.dark
              : TColors.white,
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 150,
                ),
                 Lottie.asset(TImages.orderProcessing,width: 150),
                const SizedBox(
                  height: TSizes.defaultSpace,
                ),
                Text(
                  text,
                  style: Theme.of(_).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static stopLoading() {
    Navigator.of(Get.overlayContext!).pop();
  }
}
