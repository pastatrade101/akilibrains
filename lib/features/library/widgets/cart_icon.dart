import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';
class CartIcon extends StatelessWidget {
  const CartIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(right: TSizes.defaultSpace-6),
      child: TRoundedContainer(
        backgroundColor: THelperFunctions.isDarkMode(context)?TColors.darkerGrey:TColors.white,

        padding: const EdgeInsets.all(TSizes.sm),radius: 100,
        child: Icon(Iconsax.shopping_cart,size: 24, color:THelperFunctions.isDarkMode(context)? TColors.accent: TColors.darkerGrey,),
      ),
    );
  }
}