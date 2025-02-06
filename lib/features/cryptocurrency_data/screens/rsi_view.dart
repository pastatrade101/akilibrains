import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:trade101/common/widgets/shimmer/shimmer_effect.dart';
import 'package:trade101/common/widgets/tooltip/tooltip.dart';
import 'package:trade101/features/cryptocurrency_data/screens/rsi_searchable_widget.dart';
import '../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../controller/dmi_controller.dart';
import '../controller/rsi_controller.dart';
// Import the file where you define the getAdxSign function

class RsiWidget extends StatelessWidget {
  final double rsiValue;

  const RsiWidget({super.key, required this.rsiValue});

  @override
  Widget build(BuildContext context) {
    RsiZone zone = getRsiZone(rsiValue);
    String signText = getRsiZoneText(zone);
    RsiController rsiController = Get.put(RsiController());

    return Column(
      children: [
        Obx(
          () => rsiController.isLoading.value
              ? TRoundedContainer(
                  padding: const EdgeInsets.symmetric(
                      vertical: TSizes.md, horizontal: TSizes.lg),
                  backgroundColor: signText == 'Hold Zone'
                      ? TColors.dark
                      : signText == 'Buy Zone'
                          ? TColors.success
                          : Colors.red,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'RSI Indicator',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                    color: THelperFunctions.isDarkMode(context)
                                        ? TColors.light
                                        : TColors.light,
                                    fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                  width: 120,
                                  child: RsiWidgetSearch(
                                    controller: rsiController,
                                  )),
                              const SizedBox(
                                width: 8,
                              ),
                              const RsiTimeSelectionWidget()
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            rsiValue.toStringAsFixed(2),
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color: THelperFunctions.isDarkMode(context)
                                        ? TColors.light
                                        : TColors.light),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const TooltipCrypto(
                              info:
                                  'RSI in cryptocurrency is categorized into buy zone, sell zone, and hold zone. In the buy zone (RSI below 30), prices are considered oversold, indicating a potential buying opportunity. Conversely, in the sell zone (RSI above 70), prices are deemed overbought, signaling a potential selling opportunity. The hold zone (RSI between 30 and 70) suggests a stable market where traders may hold their positions without immediate action.'),
                          Column(
                            children: [
                              Text(
                                'RSI Sign:',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        color:
                                            THelperFunctions.isDarkMode(context)
                                                ? TColors.light
                                                : TColors.light,
                                        fontWeight: FontWeight.w700),
                              ),
                              Text(
                                signText,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        color:
                                            THelperFunctions.isDarkMode(context)
                                                ? TColors.light
                                                : TColors.light),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                )
              : const TShimmerEffect(width: double.infinity, height: 120),
        ),
      ].animate(interval: 100.ms).fadeIn(duration: 800.ms),
    );
  }
}

class RsiTimeSelectionWidget extends StatelessWidget {
  const RsiTimeSelectionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RsiController controller = Get.find();

    List<int> timeSelect = controller.time;

    return GetBuilder<RsiController>(
      builder: (_) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Label for the dropdown

          // Dropdown button
          DropdownButton<int>(
            value: controller.selectedTime.value,
            onChanged: (int? newValue) {
              if (newValue != null) {
                controller.selectedTime.value = newValue;
                controller.fetchBtcRsi(controller.selectedPair.value,
                    newValue); // Fetch data for the selected time
              }
            },
            items: timeSelect.map((int time) {
              return DropdownMenuItem<int>(
                value: time,
                child: Text(
                  time.toString(),
                  style: const TextStyle(
                    color: TColors.complementary, // Text color
                    fontSize: 16.0, // Font size
                    fontWeight: FontWeight.normal, // Font weight
                    // Add more styling properties as needed
                  ),
                ),
              );
            }).toList(),
            // Dropdown button style
            style: const TextStyle(
              color: Colors.white, // Dropdown button text color
              fontSize: 16.0, // Dropdown button text font size
              fontWeight: FontWeight.normal, // Dropdown button text font weight
              // Add more styling properties as needed
            ),
            // Dropdown button icon
            icon: const Icon(
              Icons.arrow_drop_down,
              color: Colors.white, // Dropdown button icon color
            ),
            // Dropdown button icon size
            iconSize: 24.0,
            // Dropdown button icon alignment
            iconDisabledColor: Colors.grey,
            // Icon color when the dropdown is disabled
            // Dropdown button elevation
            elevation: 2,
            // Dropdown button padding
            // padding: EdgeInsets.all(10.0),
            // Dropdown button border
            // underline: Container(),
            // Dropdown button dropdownColor
            // dropdownColor: Colors.grey[200]
            // Dropdown button borderRadius
            // borderRadius: BorderRadius.circular(10.0),
            // Dropdown button width:
            // isExpanded: true,
            // Dropdown button hint
            hint: const Text(''), // Empty hint
          ),
          const Text(
            'Minute', // Displayed label
            style: TextStyle(
              color: Colors.white, // Label text color
              fontSize: 16.0, // Label text font size
              fontWeight: FontWeight.normal, // Label text font weight
              // Add more styling properties as needed
            ),
          ),
        ],
      ),
    );
  }
}
