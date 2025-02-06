import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../common/widgets/tooltip/tooltip.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../controller/dmi_controller.dart';

class PdiWidget extends StatelessWidget {
  final double pdiValue;
  final double mdiValue;

  const PdiWidget({super.key, required this.pdiValue, required this.mdiValue});

  @override
  Widget build(BuildContext context) {
    PdiSign sign = getPdiSign(pdiValue, mdiValue);
    String signText = getPdiSignText(sign);

    return Column(
      children: [
        TRoundedContainer(

          padding: const EdgeInsets.symmetric(
              vertical: TSizes.md, horizontal: TSizes.lg),
          backgroundColor: signText=='Bearish Trend'?Colors.red:signText=='No Clear Trend'? TColors.warning
              : Colors.green,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text('PDI Count (24Hrs)',style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: THelperFunctions.isDarkMode(context)
                          ? TColors.light
                          : TColors.light,fontWeight: FontWeight.bold),),
                  Text(
                    pdiValue.toStringAsFixed(2),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: THelperFunctions.isDarkMode(context)
                            ? TColors.light
                            : TColors.light),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                   Text('PDI Sign:',style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: THelperFunctions.isDarkMode(context)
                          ? TColors.light
                          : TColors.light,fontWeight: FontWeight.bold),),
                  Text(signText,style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: THelperFunctions.isDarkMode(context)
                          ? TColors.light
                          : TColors.light,fontWeight: FontWeight.normal),),
                ],
              ),const TooltipCrypto(info: 'The PDI and NDI are secondary components of the DMI and provide insights into the direction of the trend. The PDI measures the strength of upward price movements, while the NDI measures the strength of downward price movements. Both indicators range from 0 to 100. When the PDI is above the NDI, it suggests a bullish trend, indicating buying pressure. Conversely, when the NDI is above the PDI, it suggests a bearish trend, indicating selling pressure.',),
            ],
          ),
        ),
      ],
    );
  }
}
