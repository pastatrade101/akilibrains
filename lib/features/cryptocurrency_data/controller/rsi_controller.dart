import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;


class RsiController extends GetxController {
  final List<int> time =[1,5,15,30];
  var selectedTime= 30.obs;
  var selectedPair= 'BTC/USDT'.obs;
  final List<String> pairs = [
    "BTC/USDT",
    "ETH/USDT",
    "BCH/USDT",
    "XRP/USDT",
    "EOS/USDT",
    "LTC/USDT",
    "TRX/USDT",
    "ETC/USDT",
    "LINK/USDT",
    "XLM/USDT",
    "ADA/USDT",
    "XMR/USDT",
    "DASH/USDT",
    "ZEC/USDT",
    "XTZ/USDT",
    "BNB/USDT",
    "ATOM/USDT",
    "ONT/USDT",
    "IOTA/USDT",
    "BAT/USDT",
    "VET/USDT",
    "NEO/USDT",
    "QTUM/USDT",
    "IOST/USDT",
    "THETA/USDT",
    "ALGO/USDT",
    "ZIL/USDT",
    "KNC/USDT",
    "ZRX/USDT",
    "COMP/USDT",
    "OMG/USDT",
    "DOGE/USDT",
    "SXP/USDT",
    "KAVA/USDT",
    "BAND/USDT",
    "RLC/USDT",
    "WAVES/USDT",
    "MKR/USDT",
    "SNX/USDT",
    "DOT/USDT",
    "DEFI/USDT",
    "YFI/USDT",
    "BAL/USDT",
    "CRV/USDT",
    "TRB/USDT",
    "RUNE/USDT",
    "SUSHI/USDT",
    "EGLD/USDT",
    "SOL/USDT",
    "ICX/USDT",
    "STORJ/USDT",
    "BLZ/USDT",
    "UNI/USDT",
    "AVAX/USDT",
    "FTM/USDT",
    "ENJ/USDT",
    "FLM/USDT",
    "REN/USDT",
    "KSM/USDT",
    "NEAR/USDT",
    "AAVE/USDT",
    "FIL/USDT",
    "RSR/USDT",
    "LRC/USDT",
    "MATIC/USDT",
    "OCEAN/USDT",
    "BEL/USDT",
    "AXS/USDT",
    "ALPHA/USDT",
    "ZEN/USDT",
    "SKL/USDT",
    "GRT/USDT",
    "1INCH/USDT",
    "CHZ/USDT",
    "SAND/USDT",
    "ANKR/USDT",
    "LIT/USDT",
    "UNFI/USDT",
    "REEF/USDT",
    "RVN/USDT",
    "SFP/USDT",
    "XEM/USDT",
    "COTI/USDT",
    "CHR/USDT",
    "MANA/USDT",
    "ALICE/USDT",
    "HBAR/USDT",
    "ONE/USDT",
    "LINA/USDT",
    "STMX/USDT",
    "DENT/USDT",
    "CELR/USDT",
    "HOT/USDT",
    "MTL/USDT",
    "OGN/USDT",
    "NKN/USDT",
    "1000SHIB/USDT",
    "BAKE/USDT",
    "GTC/USDT",
    "BTCDOM/USDT",
    "IOTX/USDT",
    "AUDIO/USDT",
    "C98/USDT",
    "MASK/USDT",
    "ATA/USDT",
    "DYDX/USDT",
    "1000XEC/USDT",
    "GALA/USDT",
    "CELO/USDT",
    "AR/USDT",
    "KLAY/USDT",
    "ARPA/USDT",
    "CTSI/USDT",
    "LPT/USDT",
    "ENS/USDT",
    "PEOPLE/USDT",
    "ROSE/USDT",
    "DUSK/USDT",
    "FLOW/USDT",
    "IMX/USDT",
    "API3/USDT",
    "GMT/USDT",
    "APE/USDT",
    "WOO/USDT",
    "JASMY/USDT",
    "DAR/USDT",
    "GAL/USDT",
    "OP/USDT",
    "INJ/USDT",
    "STG/USDT",
    "SPELL/USDT",
    "1000LUNC/USDT",
    "LUNA2/USDT",
    "LDO/USDT",
    "CVX/USDT",
    "ICP/USDT",
    "APT/USDT",
    "QNT/USDT",
    "FET/USDT",
    "FXS/USDT",
    "HOOK/USDT",
    "MAGIC/USDT",
    "T/USDT",
    "RNDR/USDT",
    "HIGH/USDT",
    "MINA/USDT",
    "ASTR/USDT",
    "AGIX/USDT",
    "PHB/USDT",
    "GMX/USDT",
    "CFX/USDT",
    "STX/USDT",
    "BNX/USDT",
    "ACH/USDT",
    "SSV/USDT",
    "CKB/USDT",
    "PERP/USDT",
    "TRU/USDT",
    "LQTY/USDT",
    "USDC/USDT",
    "ID/USDT",
    "ARB/USDT",
    "JOE/USDT",
    "AMB/USDT",
    "TLM/USDT",
    "LEVER/USDT",
    "RDNT/USDT",
    "HFT/USDT",
    "XVS/USDT",
    "ETH/BTC",
    "BLUR/USDT",
    "EDU/USDT",
    "IDEX/USDT",
    "SUI/USDT",
    "1000PEPE/USDT",
    "1000FLOKI/USDT",
    "RAD/USDT",
    "UMA/USDT",
    "KEY/USDT",
    "COMBO/USDT",
    "NMR/USDT",
    "MAV/USDT",
    "MDT/USDT",
    "XVG/USDT",
    "WLD/USDT",
    "PENDLE/USDT",
    "ARKM/USDT",
    "AGLD/USDT",
    "YGG/USDT",
    "DODOX/USDT",
    "BNT/USDT",
    "OXT/USDT",
    "SEI/USDT",
    "CYBER/USDT",
    "HIFI/USDT",
    "ARK/USDT",
    "FRONT/USDT",
    "GLMR/USDT",
    "BICO/USDT",
    "LOOM/USDT",
    "BIGTIME/USDT",
    "BOND/USDT",
    "ORBS/USDT",
    "STPT/USDT",
    "WAXP/USDT",
    "BSV/USDT",
    "RIF/USDT",
    "POLYX/USDT",
    "GAS/USDT",
    "POWR/USDT",
    "SLP/USDT",
    "TIA/USDT",
    "SNT/USDT",
    "CAKE/USDT",
    "MEME/USDT",
    "TWT/USDT",
    "TOKEN/USDT",
    "ORDI/USDT",
    "STEEM/USDT",
    "BADGER/USDT",
    "ILV/USDT",
    "NTRN/USDT",
    "MBL/USDT",
    "KAS/USDT",
    "BEAMX/USDT",
    "1000BONK/USDT",
    "PYTH/USDT",
    "SUPER/USDT",
    "USTC/USDT",
    "ONG/USDT",
    "ETHW/USDT",
    "JTO/USDT",
    "1000SATS/USDT",
    "AUCTION/USDT",
    "1000RATS/USDT",
    "ACE/USDT",
    "MOVR/USDT",
    "NFP/USDT",
    "BTC/USDC",
    "ETH/USDC",
    "BNB/USDC",
    "SOL/USDC",
    "XRP/USDC",
    "AI/USDT",
    "XAI/USDT",
    "DOGE/USDC",
    "WIF/USDT",
    "MANTA/USDT",
    "ONDO/USDT",
    "LSK/USDT",
    "ALT/USDT",
    "JUP/USDT",
    "ZETA/USDT",
    "RONIN/USDT",
    "DYM/USDT",
    "SUI/USDC",
    "OM/USDT",
    "LINK/USDC",
    "PIXEL/USDT",
    "STRK/USDT",
    "MAVIA/USDT",
    "ORDI/USDC",
    "GLM/USDT",
    "PORTAL/USDT",
    "TON/USDT",
    "AXL/USDT",
    "MYRO/USDT",
    "1000PEPE/USDC",
    "METIS/USDT",
    "AEVO/USDT",
    "WLD/USDC",
    "VANRY/USDT",
    "BOME/USDT",
    "ETHFI/USDT",
    "AVAX/USDC",
    "1000SHIB/USDC",
    "ENA/USDT",
    "W/USDT",
    "WIF/USDC",
    "BCH/USDC",
    "TNSR/USDT",
    "SAGA/USDT",
    "LTC/USDC",
    "NEAR/USDC",
    "TAO/USDT",
    "OMNI/USDT",
    "ARB/USDC",
    "NEO/USDC",
    "FIL/USDC",
    "MATIC/USDC",
    "TIA/USDC",
    "BOME/USDC"
  ];
  final rsi = 0.0.obs;
  final agixRsi = 0.0.obs;
  final aktRsi = 0.0.obs;
  final tokenRsi = 0.0.obs;
RxBool isLoading = false.obs;

  @override
  void onInit() {
    fetchBtcRsi(selectedPair.value,selectedTime.value);

    super.onInit();
  }

  Future<void> fetchBtcRsi(String pair,int time) async {

    try {
      isLoading.value = false;
      final response = await http.get(Uri.parse('https://api.taapi.io/rsi?secret=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjbHVlIjoiNjYyYTA0ZDBmNWFmOTRlZWNlNDRjNDI1IiwiaWF0IjoxNzE0MDMwMDY5LCJleHAiOjMzMjE4NDk0MDY5fQ.DEC8WbJiwjjgBwE6uip_0c8aj2Q2QPXsgt6vFMhSyI4&exchange=binance&symbol=$pair&interval=${time}m'));

      if (response.statusCode == 200) {
        isLoading.value = true;
        final data = json.decode(response.body);

        rsi.value = data['value'];

      } else {
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception occurred: $e');
    }
  }






}
enum RsiZone {
  buy,
  sell,
  hold,
}

RsiZone getRsiZone(double rsiValue) {
  if (rsiValue < 30) {
    return RsiZone.buy;
  } else if (rsiValue > 70) {
    return RsiZone.sell;
  } else {
    return RsiZone.hold;
  }
}

String getRsiZoneText(RsiZone zone) {
  switch (zone) {
    case RsiZone.buy:
      return 'Buy Zone';
    case RsiZone.sell:
      return 'Sell Zone';
    case RsiZone.hold:
      return 'Hold Zone';
    default:
      return '';
  }
}