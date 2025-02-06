import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../controller/cmf_controller.dart';
// Import the controller

class CmfChart extends StatelessWidget {
  const CmfChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cmfController = Get.find<CmfController>(); // Get the controller instance

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Display the CMF average value (optional)

          const SizedBox(height: 20.0),
        SfCartesianChart(
          series: <CartesianSeries<CmfData, int>>[
            LineSeries<CmfData, int>(
              dataSource: cmfController.dataListChart.value,
              xValueMapper: (CmfData data, _) => data.backtrack,
              yValueMapper: (CmfData data, _) => data.value,
              name: 'CMF',
              markerSettings: const MarkerSettings(isVisible: true),
            ),
          ],
          primaryXAxis: const NumericAxis(
            title: AxisTitle(text: 'Backtrack (Days)'),minimum: 1, // Adjust this value based on your data
            maximum: 10,interval: 1,
          ),
          primaryYAxis: const NumericAxis(
            title: AxisTitle(text: 'CMF'),
            // Set a fixed range for the Y-axis
            minimum: 0.1, // Adjust this value based on your data
            maximum: 0.4, // Adjust this value based on your data
          ),
        ),


          // Button to trigger data fetching (optional)

        ],
      ),
    );
  }
}

class CmfData {
  final double value;
  final int backtrack;

  const CmfData(this.value, this.backtrack);
}
