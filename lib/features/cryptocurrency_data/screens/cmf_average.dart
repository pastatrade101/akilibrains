import 'dart:async';


import 'package:flutter/material.dart';

import '../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../controller/cmf_controller.dart';

// Import the file where you define the getAdxSign function

class CmfAvgWidget extends StatelessWidget {
  final double cmfAvgValue;

  const CmfAvgWidget({super.key, required this.cmfAvgValue});

  @override
  Widget build(BuildContext context) {
    CmfZone zone = getCmfZone(cmfAvgValue);
    String signText = getCmfZoneText(zone);


    return Column(
      children: [
        TRoundedContainer(
          padding: const EdgeInsets.symmetric(
              vertical: TSizes.md, horizontal: TSizes.lg),
          backgroundColor: signText=='Accumulation (Buy) Zone'?TColors.success:signText=='Distribution (Sell) Zone'?Colors.red:TColors.darkGrey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('CMF (10 Days ago)',style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: THelperFunctions.isDarkMode(context)
                          ? TColors.light
                          : TColors.light,fontWeight: FontWeight.w700),),
                  Text(
                    cmfAvgValue.toStringAsFixed(2),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: THelperFunctions.isDarkMode(context)
                            ? TColors.light
                            : TColors.light),
                  ),
                ],
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Money Flow',style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: THelperFunctions.isDarkMode(context)
                          ? TColors.light
                          : TColors.light,fontWeight: FontWeight.w700),overflow: TextOverflow.ellipsis,maxLines: 1,),
                  SizedBox(width: 150,
                    child: Text(signText,style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: THelperFunctions.isDarkMode(context)
                            ? TColors.light
                            : TColors.light),overflow: TextOverflow.ellipsis,maxLines: 1,),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
