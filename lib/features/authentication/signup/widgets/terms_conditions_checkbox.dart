import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';


import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../controller/signup_controller.dart';

class TTermsAndConditionCheckbox extends StatelessWidget {
  const TTermsAndConditionCheckbox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = SignupController.instance;
    return Row(
      children: [
        // Wrap in a Sized box to remove extra padding
        SizedBox(
            width: 24,
            height: 24,
            child: Obx(() => Checkbox(
                value: controller.policyCheck.value,
                onChanged: (value) {
                  controller.policyCheck.value = !controller.policyCheck.value;
                }))),
        const SizedBox(width: TSizes.md),
        Flexible(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                    text: '${TTexts.iAgreeTo} ',
                    style: Theme.of(context).textTheme.bodySmall),
                TextSpan(
                  text: TTexts.privacyPolicy,
                  style: Theme.of(context).textTheme.bodyMedium!.apply(
                        color: THelperFunctions.isDarkMode(context)
                            ? TColors.white
                            : TColors.primary,
                        decoration: TextDecoration.underline,
                        decorationColor: THelperFunctions.isDarkMode(context)
                            ? TColors.white
                            : TColors.primary,
                      ),
                ),
                TextSpan(
                    text: ' ${TTexts.and} ',
                    style: Theme.of(context).textTheme.bodySmall),
                TextSpan(
                  text: TTexts.termsOfUse,
                  style: Theme.of(context).textTheme.bodyMedium!.apply(
                        color: THelperFunctions.isDarkMode(context)
                            ? TColors.white
                            : TColors.primary,
                        decoration: TextDecoration.underline,
                        decorationColor: THelperFunctions.isDarkMode(context)
                            ? TColors.white
                            : TColors.primary,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
