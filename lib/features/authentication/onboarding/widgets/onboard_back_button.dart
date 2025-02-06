import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../../../utils/constants/colors.dart';
import '../controllers/onboarding/onboarding_controller.dart';
class OnboardingBackButton extends StatelessWidget {
  const OnboardingBackButton({
    super.key,
    required this.dark,
  });

  final bool dark;

  @override
  Widget build(BuildContext context) {
    final controller = OnBoardingController.instance;
    return Obx(
        ()=>  controller.currentPageIndex.value==2?const SizedBox():  Expanded(
        child: ElevatedButton(

              onPressed: () => OnBoardingController.instance.backPage(),
              style: ElevatedButton.styleFrom(

                  side: BorderSide(color: OnBoardingController
                      .instance.currentPageIndex.value ==
                      0
                      ? TColors.buttonDisabled
                      : TColors.primary),
                  backgroundColor: dark ? TColors.black : Colors.white),
              child: Text(
                'Back',
                style: TextStyle(
                    color: OnBoardingController
                        .instance.currentPageIndex.value ==
                        0
                        ? TColors.buttonDisabled
                        : TColors.primary),
              )),
        ),
    );

  }
}