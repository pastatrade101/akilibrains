import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/device/device_utility.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../controllers/onboarding/onboarding_controller.dart';


class TOnBoardingDotNavigation extends StatelessWidget {
  const TOnBoardingDotNavigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = OnBoardingController.instance;
    final dark = THelperFunctions.isDarkMode(context);

    return Positioned(
      bottom: TDeviceUtils.getBottomNavigationBarHeight() +42,

      child: SizedBox(width: THelperFunctions.screenWidth(),
        child: Center(
          child: SmoothPageIndicator(
            count: 3,
            controller: controller.pageController,
            onDotClicked: controller.dotNavigationClick,
            effect: ExpandingDotsEffect(activeDotColor: dark ? TColors.white: TColors.primary, dotHeight: 6),
          ),
        ),
      ),
    );
  }
}