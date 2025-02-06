import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../screens/cmf_chart.dart';

class CmfController extends GetxController {
  final cmf = 0.0.obs;
  final cmfAverageValue = 0.0.obs;
  final dataListChart = <CmfData>[].obs;


  @override
  void onInit() {
    fetchCmfData();
    super.onInit();
  }

  Future<void> fetchCmfData() async {
    const url =
        'https://api.taapi.io/cmf?secret=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjbHVlIjoiNjYyYTA0ZDBmNWFmOTRlZWNlNDRjNDI1IiwiaWF0IjoxNzE0MDMwMDY5LCJleHAiOjMzMjE4NDk0MDY5fQ.DEC8WbJiwjjgBwE6uip_0c8aj2Q2QPXsgt6vFMhSyI4&exchange=binance&symbol=BTC/USDT&interval=1d&backtracks=10';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> dataList = json.decode(response.body);
        for (final dynamic data in dataList) {
          final cmfData = CmfData(
            double.parse(data['value'].toString()), // Convert dynamic to double
            int.parse(data['backtrack'].toString()), // Convert dynamic to int
          );
          dataListChart.add(cmfData);
        }
        print('Data list-------------------------------: $dataList');
        // Calculate the average value
        double totalValue = 0;
        for (final data in dataList) {
          totalValue += data['value'];
        }
         cmfAverageValue.value = totalValue / dataList.length;


        // Get the CMF zone
        final cmfZone = getCmfZone(cmfAverageValue.value);

        // Print the CMF zone text
        print('CMF Zone: ${getCmfZoneText(cmfZone)}');

      } else {
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception occurred: $e');
    }
  }


}



enum CmfZone {
  buy,
  sell,
  hold,
}

CmfZone getCmfZone(double cmfValue) {
  if (cmfValue > 0) {
    return CmfZone.buy;
  } else if (cmfValue < 0) {
    return CmfZone.sell;
  } else {
    return CmfZone.hold;
  }
}

String getCmfZoneText(CmfZone zone) {
  switch (zone) {
    case CmfZone.buy:
      return 'Accumulation (Buy) Zone';
    case CmfZone.sell:
      return 'Distribution (Sell) Zone';
    case CmfZone.hold:
      return 'Neutral (Hold) Zone';
    default:
      return '';
  }
}
