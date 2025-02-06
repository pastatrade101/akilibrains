import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class DmiController extends GetxController {
  final adx = 0.0.obs;
  final pdi = 0.0.obs;
  final mdi = 0.0.obs;

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  Future<void> fetchData() async {
    const url =
        'https://api.taapi.io/dmi?secret=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjbHVlIjoiNjYyYTA0ZDBmNWFmOTRlZWNlNDRjNDI1IiwiaWF0IjoxNzE0MDMwMDY5LCJleHAiOjMzMjE4NDk0MDY5fQ.DEC8WbJiwjjgBwE6uip_0c8aj2Q2QPXsgt6vFMhSyI4&exchange=binance&symbol=BTC/USDT&interval=1h';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        adx.value = data['adx'];
        pdi.value = data['pdi'];
        mdi.value = data['mdi'];
      } else {
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception occurred: $e');
    }
  }


}
enum AdxSign {
  strongUptrend,
  strongDowntrend,
  weakTrend,
  trendConfirmation,
  noTrend,
  volatilityWarning,
}

AdxSign getAdxSign(double adxValue) {
  if (adxValue > 25) {
    // ADX value above 25
    if (adxValue.isInfinite || adxValue.isNaN) {
      // Handle invalid or NaN ADX values
      return AdxSign.noTrend;
    } else {
      // Determine trend direction based on ADX value
      if (adxValue.isNegative) {
        return AdxSign.strongDowntrend;
      } else {
        return AdxSign.strongUptrend;
      }
    }
  } else if (adxValue < 20) {
    // ADX value below 20
    return AdxSign.noTrend;
  } else {
    // ADX value between 20 and 25
    return AdxSign.weakTrend;
  }
}

String getAdxSignText(AdxSign sign) {
  switch (sign) {
    case AdxSign.strongUptrend:
      return 'Strong Uptrend';
    case AdxSign.strongDowntrend:
      return 'Strong Downtrend';
    case AdxSign.weakTrend:
      return 'Weak Trend';
    case AdxSign.trendConfirmation:
      return 'Trend Confirmation';
    case AdxSign.noTrend:
      return 'No Trend';
    case AdxSign.volatilityWarning:
      return 'Volatility Warning';
    default:
      return '';
  }
}

enum PdiSign {
  bullishTrend,
  bearishTrend,
  noTrend,
}

PdiSign getPdiSign(double pdiValue, double mdiValue) {
  if (pdiValue > mdiValue) {
    // PDI is greater than MDI, indicating a bullish trend
    return PdiSign.bullishTrend;
  } else if (pdiValue < mdiValue) {
    // PDI is less than MDI, indicating a bearish trend
    return PdiSign.bearishTrend;
  } else {
    // PDI is equal to MDI, indicating no clear trend
    return PdiSign.noTrend;
  }
}

String getPdiSignText(PdiSign sign) {
  switch (sign) {
    case PdiSign.bullishTrend:
      return 'Bullish Trend';
    case PdiSign.bearishTrend:
      return 'Bearish Trend';
    case PdiSign.noTrend:
      return 'No Clear Trend';
    default:
      return '';
  }
}
