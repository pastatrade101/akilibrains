import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:trade101/features/cryptocurrency_data/controller/pivots_controller.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../controller/fibonacciretracement_controller.dart';

class Crypto {
  final String symbol;

  Crypto({required this.symbol});
}

class PivotPairSelectionWidgetCrypto extends StatelessWidget {
  final PivotController controller;

  const PivotPairSelectionWidgetCrypto({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> filteredPairs = controller.pairs;

    // Convert the list of strings to a list of Crypto objects
    List<Crypto> cryptos = filteredPairs
        .map((pair) => Crypto(symbol: pair,)) // You can set name as needed
        .toList();

    return TypeAheadField<Crypto>(
      builder: (context, controller, focusNode) {
        return TextFormField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          focusNode: focusNode,
          autofocus: false,
          decoration: InputDecoration(


            labelStyle:  TextStyle(color: THelperFunctions.isDarkMode(context)?Colors.white:Colors.white),
            contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey), // Define border color for unfocused state
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color:TColors.complementary), // Define border color for focused state
            ),
            labelText: '${this.controller.selectedPair}',
            hintStyle: TextStyle(color: THelperFunctions.isDarkMode(context)?Colors.white:Colors.white),


          ),
        );
      },
      suggestionsCallback: (search) => _getSuggestions(cryptos, search),
      itemBuilder: (context, Crypto crypto) {
        return Container(
          width: double.infinity,
          color: TColors.black,
          child: ListTile(
            title: Text(crypto.symbol,style: const TextStyle(color: TColors.complementary),),
          ),
        );
      },
      onSelected: (Crypto crypto) {
        // Do something with the selected crypto
        this.controller.selectedPair.value = crypto.symbol;
        this.controller.fetchData(crypto.symbol, this.controller.selectedTime.value);
      },
    );
  }

  // Function to get suggestions based on the search query
  List<Crypto> _getSuggestions(List<Crypto> cryptos, String query) {
    return cryptos
        .where((crypto) => crypto.symbol.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
