import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../utils/constants/colors.dart';
import '../controller/pivots_controller.dart';

class PivotPointCard extends StatelessWidget {
  final String label;
  final double value;

  const PivotPointCard({Key? key, required this.label, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PivotController pivotController = Get.put(PivotController());
    return Obx(
        ()=> pivotController.isLoading.value
              ? const CircularProgressIndicator()
              :   Padding(
        padding: const EdgeInsets.all(8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: TColors.light),
            ),
            const SizedBox(height: 5),
            Text(
              value.toStringAsFixed(2), // Displaying up to 2 decimal places
              style: const TextStyle(
                fontSize: 16,fontWeight: FontWeight.bold,color: TColors.complementary
              ),
            ),

          ],
        ),
      ),
    );
  }
}


class PivotTimeSelectionWidget extends StatelessWidget {

  const PivotTimeSelectionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PivotController controller = Get.find();

    List<int> timeSelect = controller.time;

    return GetBuilder<PivotController>(
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
                controller.fetchData(
                    controller.selectedPair.value, newValue); // Fetch data for the selected time
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
          ), const Text(
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