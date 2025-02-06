import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';

class BookPriceText extends StatelessWidget {
  const BookPriceText({
    super.key,
    this.currencySign = 'TZS',
    required this.price,
    this.isLarge = false,
    this.maxLines = 1,
    this.lineThrough = false,
  });

  final String currencySign, price;
  final int maxLines;
  final bool isLarge;
  final bool lineThrough;

  @override
  Widget build(BuildContext context) {
    return Text(
      currencySign + price,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: isLarge
          ? Theme.of(context).textTheme.bodyLarge!.apply(
          decoration: lineThrough ? TextDecoration.lineThrough : null,
          color: TColors.secondary)
          : Theme.of(context).textTheme.labelMedium!.apply(
          decoration: lineThrough ? TextDecoration.lineThrough : null,
          color: TColors.accent),
    );
  }
}
