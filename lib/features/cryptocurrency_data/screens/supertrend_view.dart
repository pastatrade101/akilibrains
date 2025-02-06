import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:trade101/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:trade101/common/widgets/texts/section_heading.dart';
import 'package:trade101/features/cryptocurrency_data/screens/supertrend_searchable_widget.dart';

import '../../../common/widgets/tooltip/tooltip.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../controller/supertrend_controller.dart';

class SuperTrendWidget extends StatelessWidget {
  final RxMap<dynamic, dynamic> responseData;

  const SuperTrendWidget({Key? key, required this.responseData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SuperTrendController superTrendController =
        Get.put(SuperTrendController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TRoundedContainer(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          backgroundColor: THelperFunctions.isDarkMode(context)
              ? TColors.dark
              : TColors.dark,
          child: Column(
            children: [
              const TSectionHeading(
                  title: 'SuperTrend Indicator', showActionButton: false,textColor: TColors.white),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                          width: 120,
                          child: SuperTrendWidgetSearch(
                            controller: superTrendController,
                          )),
                      const SizedBox(
                        width: 16,
                      ),
                      const SuperTrendTimeSelectionWidget()
                    ],
                  ),
                  Obx(() => TRoundedContainer(
                        backgroundColor: responseData["valueAdvice"] == 'long'
                            ? Colors.green
                            : Colors.red,
                        child: responseData["valueAdvice"] == 'long'
                            ? const Icon(Icons.arrow_upward,
                                size: 16, color: TColors.light)
                            : const Icon(Icons.arrow_downward,
                                size: 16, color: TColors.light),
                      )),
                  const TooltipCrypto(
                    info:
                        'The Supertrend indicator, blending price and volatility, identifies trend directions and reversals. It calculates bands around the price chart based on average true range (ATR) and a user-set multiplier. Crossing above the upper band signals a long (buy) opportunity, while dipping below the lower band suggests a short (sell) opportunity.',
                  )
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SuperTrend Value',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: TColors.white),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        '${responseData["value"].toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(color: TColors.complementary),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Advice',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: TColors.white),
                      ),
                      Text(
                        '${responseData["valueAdvice"]}',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(color: TColors.complementary),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}

// Class for display Timeframe for Super Trend Widget
class SuperTrendTimeSelectionWidget extends StatelessWidget {
  const SuperTrendTimeSelectionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SuperTrendController controller = Get.find();

    List<int> timeSelect = controller.time;

    return GetBuilder<SuperTrendController>(
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
                controller.fetchData(controller.selectedPair.value,
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
