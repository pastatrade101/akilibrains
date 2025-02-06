import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/device/device_utility.dart';

import '../../../../utils/constants/colors.dart';
import '../controllers/onboarding/onboarding_controller.dart';

class TOnBoardingSkipButton extends StatelessWidget {
  const TOnBoardingSkipButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OnBoardingController.instance;

    return Positioned(
      top: TDeviceUtils.getAppBarHeight(),
      right: TSizes.defaultSpace,
      child:  Obx(
          ()=> controller.currentPageIndex.value==2?const Text(''): TextButton(
            onPressed: controller.skipPage,
            child: const Text(
              'Skip',
              style: TextStyle(
                  fontSize: 16,
                  color: TColors.accent,
                  fontWeight: FontWeight.w500),
            )),
      ),
    );
  }
}
