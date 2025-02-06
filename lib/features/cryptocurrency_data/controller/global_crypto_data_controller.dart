import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../data/repositories/authentication/authentication_repository.dart';

class CryptoController extends GetxController {
  final ethDominance = 0.0.obs;
  final btcDominance = 0.0.obs;
  final defiVolume24h = 0.0.obs;
  final totalMarketCap = 0.0.obs;
  final lastUpdated = 0.0.obs;


  @override
  void onInit() {
    fetchData();
    super.onInit();

  }


  Future<void> fetchData() async {
    const url =
        'https://pro-api.coinmarketcap.com/v1/global-metrics/quotes/latest';
    const apiKey = '92460512-65d1-445d-93f3-1b4ecce24cb7';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'X-CMC_PRO_API_KEY': apiKey,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        ethDominance.value = data['data']['eth_dominance'];
        btcDominance.value = data['data']['btc_dominance'];
        defiVolume24h.value = data['data']['defi_volume_24h'];
        totalMarketCap.value = data['data']['quote']['USD']['total_market_cap'];
        lastUpdated.value = data['data']['quote']['USD']['last_updated'];
        print('Failed to fetch data: ${data['data']['quote']['USD']['last_updated']}');

      } else {
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception occurred: $e');
    }
  }
}
