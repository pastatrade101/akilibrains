import 'package:flutter/material.dart';


import '../../../utils/constants/colors.dart';
import '../../../utils/helpers/helper_functions.dart';
class PriceWidget extends StatelessWidget {
  const PriceWidget({
    super.key, required this.price,
  });
final String price;
  @override
  Widget build(BuildContext context) {
    return  Text(
      '$price TZS',
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: THelperFunctions.isDarkMode(context)? TColors.accent:TColors.accent),
    );
  }
}