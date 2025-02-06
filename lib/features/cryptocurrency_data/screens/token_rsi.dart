import 'dart:async';


import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';

import '../controller/rsi_controller.dart';
// Import the file where you define the getAdxSign function

class TokenRsiWidget extends StatelessWidget {
  final double tokenRsiValue;

  const TokenRsiWidget({super.key, required this.tokenRsiValue});

  @override
  Widget build(BuildContext context) {
    RsiZone zone = getRsiZone(tokenRsiValue);
    String signText = getRsiZoneText(zone);


    return Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TRoundedContainer(
          padding: const EdgeInsets.symmetric(
              vertical: TSizes.sm, horizontal: TSizes.md),
          backgroundColor: signText=='Hold Zone'?TColors.darkGrey:signText=='Buy Zone'?TColors.success:Colors.red,
          child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('TOKEN/USD (4H)',style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: THelperFunctions.isDarkMode(context)
                          ? TColors.light
                          : TColors.light,fontWeight: FontWeight.w700),),
                  Text(
                    tokenRsiValue.toStringAsFixed(2),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: THelperFunctions.isDarkMode(context)
                            ? TColors.light
                            : TColors.light),
                  ), Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('RSI Sign:',style: Theme.of(context).textTheme.titleMedium!.copyWith(
                              color: THelperFunctions.isDarkMode(context)
                                  ? TColors.light
                                  : TColors.light,fontWeight: FontWeight.w700),),
                        ],
                      ),
                      Text(signText,style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: THelperFunctions.isDarkMode(context)
                              ? TColors.light
                              : TColors.light),),
                    ],
                  )
                ],
              ),



        ),
      ].animate(interval: 100.ms).fadeIn(duration: 200.ms),
    );
  }
}
