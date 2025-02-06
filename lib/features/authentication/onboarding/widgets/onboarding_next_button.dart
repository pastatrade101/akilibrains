import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/device/device_utility.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../controllers/onboarding/onboarding_controller.dart';
import 'onboard_back_button.dart';

class TOnBoardingNextButton extends StatelessWidget {
  const TOnBoardingNextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = OnBoardingController.instance;
    return Positioned(
      right: TSizes.defaultSpace,
      left: TSizes.defaultSpace,
      bottom: TDeviceUtils.getBottomNavigationBarHeight()-32,
      child: Row(
        children: [
          // -----Onboarding Back button
          OnboardingBackButton(dark: dark),
          const SizedBox(
            width: TSizes.sm,
          ),


          Expanded(
            // Onboarding next button
            child: Obx(
                ()=> controller.currentPageIndex.value==2?Animate(effects: const [FadeEffect(), ScaleEffect(curve: Curves.decelerate)],
                  child: ElevatedButton(
                      onPressed: () => OnBoardingController.instance.nextPage(),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: dark ? TColors.primary : TColors.primary),
                      child:  Text('Start Shopping',style: Theme.of(context).textTheme.titleLarge!.copyWith(color: THelperFunctions.isDarkMode(context)?TColors.accent:TColors.light),)),
                ): ElevatedButton(
                  onPressed: () => OnBoardingController.instance.nextPage(),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: dark ? TColors.primary : TColors.primary),
                  child:  Text('Next',style: Theme.of(context).textTheme.titleLarge!.copyWith(color: THelperFunctions.isDarkMode(context)?TColors.accent:TColors.light))),
            ),
          )
        ],
      ),
    );
  }
}


