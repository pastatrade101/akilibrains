import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:trade101/common/widgets/shimmer/shimmer_effect.dart';
import 'package:trade101/features/cryptocurrency_data/screens/fibonacci_searchable_widget.dart';
import '../../../common/widgets/texts/section_heading.dart';
import '../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../controller/fibonacciretracement_controller.dart';

class FibonacciRetracementWidget extends StatelessWidget {
  const FibonacciRetracementWidget({Key? key, required String pair})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FibonacciRetracementController fibonacciRetracementController =
        Get.put(FibonacciRetracementController());

    return Center(
      child: Obx(() {
        if (fibonacciRetracementController.isLoading.value) {
          return const TShimmerEffect(width: double.infinity, height: 200);
        } else {
          final data = fibonacciRetracementController.responseData;
          final value = '\$${_formatNumber(data['value'].toDouble())}';
          final trend = data['trend'];
          final startPrice =
              '\$${_formatNumber(data['startPrice'].toDouble())}';
          final endPrice = '\$${_formatNumber(data['endPrice'].toDouble())}';
          // final startTimestamp = _formatTimestamp(data['startTimestamp']);
          // final endTimestamp = _formatTimestamp(data['endTimestamp']);

          return TRoundedContainer(
            backgroundColor: THelperFunctions.isDarkMode(context)
                ? TColors.dark
                : TColors.dark,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TSectionHeading(
                    title: 'Fibonacci retracement', showActionButton: false,textColor: TColors.white),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Row(
                      children: [
                        SizedBox(width: 120, child: FibonancciPairSelectionWidgetCrypto(controller: fibonacciRetracementController,)),
                        const SizedBox(
                          width: TSizes.md,
                        ),
                        const FibonacciTimeSelectionWidget()
                      ],
                    ),
                    Obx(() => TRoundedContainer(
                          backgroundColor: fibonacciRetracementController
                                      .responseData['trend'] ==
                                  'UPTREND'
                              ? Colors.green
                              : Colors.red,
                          child: fibonacciRetracementController
                                      .responseData['trend'] ==
                                  'UPTREND'
                              ? const Icon(Icons.arrow_upward,
                                  color: TColors.light)
                              : const Icon(Icons.arrow_downward,
                                  color: TColors.light),
                        ))
                  ],
                ), // New widget for selecting the pair
                const SizedBox(height: 16),
                DataWidget(label: 'Key Level', value: value),
                DataWidget(label: 'Trend', value: trend),
                DataWidget(label: 'Start Price', value: startPrice),
                DataWidget(label: 'End Price', value: endPrice),
                // DataWidget(label: 'Start Timestamp', value: startTimestamp),
                // DataWidget(label: 'End Timestamp', value: endTimestamp),
              ],
            ),
          );
        }
      }),
    );
  }

  String _formatTimestamp(int timestamp) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final formattedHour = DateFormat('HH:mm').format(dateTime);
    return formattedHour;
  }

  String _formatNumber(double number) {
    final formatter = NumberFormat('#,##0.00', 'en_US');
    return formatter.format(number);
  }
}

// DataWidget widget definition
class DataWidget extends StatelessWidget {
  final String label;
  final dynamic value;

  const DataWidget({Key? key, required this.label, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: TColors.light),
          ),
          const SizedBox(width: 10),
          Text(
            '$value',
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.bold,color: TColors.complementary),
          ),
        ],
      ),
    );
  }
}

class PairSelectionWidget extends StatelessWidget {
  final FibonacciRetracementController fibonacciRetracementController =
      Get.put(FibonacciRetracementController());

  PairSelectionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FibonacciRetracementController controller = Get.find();

    List<String> filteredPairs = controller.pairs;

    return SizedBox(
      // Wrap with SizedBox to provide a fixed width
      width: 200, // Adjust the width according to your layout
      child: GetBuilder<FibonacciRetracementController>(
        builder: (_) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: controller.selectedPair.value,
                onChanged: (String? newValue) {
                  controller.selectedPair.value = newValue!;
                  controller.fetchData(
                      newValue,
                      controller.selectedTime
                          .value); // Fetch data for the selected pair
                },
                items: filteredPairs.map((String pair) {
                  return DropdownMenuItem<String>(
                    value: pair,
                    child: Text(
                      pair,
                      style: const TextStyle(
                        color: TColors.complementary, // Text color
                        fontSize: 16.0, // Font size
                        fontWeight: FontWeight.normal, // Font weight
                        // Add more styling properties as needed
                      ),
                    ),
                  );
                }).toList(),
                style: const TextStyle(
                  color: Colors.white, // Dropdown button text color
                  fontSize: 16.0, // Dropdown button text font size
                  fontWeight:
                      FontWeight.normal, // Dropdown button text font weight
                  // Add more styling properties as needed
                ),
                icon: const Icon(

                  Icons.arrow_drop_down,
                  color: Colors.white, // Dropdown button icon color
                ),
                iconSize: 24.0,
                elevation: 2,
                hint: const Text('Select Pair'),
                decoration: const InputDecoration(
                  // Search field decoration
                  border: OutlineInputBorder(),
                  labelText: 'Search Pair', // Placeholder text for search field
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FibonacciTimeSelectionWidget extends StatelessWidget {
  const FibonacciTimeSelectionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FibonacciRetracementController controller = Get.find();

    List<int> timeSelect = controller.time;

    return GetBuilder<FibonacciRetracementController>(
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
