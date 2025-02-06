import 'package:flutter/material.dart';

import '../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';
class CategoryWidget extends StatelessWidget {
  const CategoryWidget({
    super.key,
    required this.categoryName,

  });

  final String categoryName;


  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
      showBorder: THelperFunctions.isDarkMode(context) ? true : false,
      borderColor:
      THelperFunctions.isDarkMode(context) ? TColors.primaryBackground.withOpacity(0.2) : TColors.white,
      backgroundColor:
      THelperFunctions.isDarkMode(context) ? TColors.dark : TColors.white,
      child: Row(
        children: [

          Text(
            categoryName,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: THelperFunctions.isDarkMode(context)
                    ? Colors.white
                    : TColors.darkerGrey),
          )
        ],
      ),
    );
  }
}