
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../controller/dmi_controller.dart';
// Import the file where you define the getAdxSign function

class AdxWidget extends StatelessWidget {
  final double adxValue;

  const AdxWidget({super.key, required this.adxValue});

  @override
  Widget build(BuildContext context) {
    AdxSign sign = getAdxSign(adxValue);
    String signText = getAdxSignText(sign);

    return Column(
      children: [
        TRoundedContainer(
          padding: const EdgeInsets.symmetric(
              vertical: TSizes.md, horizontal: TSizes.lg),
          backgroundColor: signText=='Strong Uptrend'?TColors.success:TColors.warning,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ADX Count (24Hrs)',style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: THelperFunctions.isDarkMode(context)
                          ? TColors.light
                          : TColors.light,fontWeight: FontWeight.w700),),
                  Text(
                    adxValue.toStringAsFixed(2),
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: THelperFunctions.isDarkMode(context)
                              ? TColors.light
                              : TColors.light),
                  ),
                ],
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                   Text('ADX Sign:',style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: THelperFunctions.isDarkMode(context)
                          ? TColors.light
                          : TColors.light,fontWeight: FontWeight.w700),),
                  Text(signText,style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: THelperFunctions.isDarkMode(context)
                          ? TColors.light
                          : TColors.light),),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
