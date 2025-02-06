import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../models/book_model.dart';
import 'cart_controller.dart';


class TBottomAddToCart extends StatelessWidget {
  const TBottomAddToCart({
    super.key,
    required this.book,
  });

  final BookModel book;

  @override
  Widget build(BuildContext context) {
    final controller = CartController.instance;
    controller.updateAlreadyAddedProductCount(book);
    final dark = THelperFunctions.isDarkMode(context);

    return Container(

      decoration: const BoxDecoration(

        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(TSizes.cardRadiusLg),
          topRight: Radius.circular(TSizes.cardRadiusLg),
        ),
      ),
      child: Obx(
            () => Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Add OR Remove Cart Product Icon Buttons
            // TProductQuantityWithAddRemoveButton(showAddIcon: true,
            //   quantity: controller.bookQuantityInCart.value,
            //   add: () => controller.bookQuantityInCart.value =1,
            //   // Disable remove when cart count is less then 1
            //   remove: () => controller.bookQuantityInCart.value < 1 ? null : controller.bookQuantityInCart.value -= 1,
            // ),
            // Add to cart button
            TextButton(
              onPressed: controller.bookQuantityInCart.value < 1 ? null : () => controller.addToCart(book),
              style: TextButton.styleFrom(
backgroundColor: dark ? TColors.dark : TColors.light,


              ),
              child:  Row(
                children: [ Icon(Iconsax.shopping_bag,color: dark ? TColors.light : TColors.accent,), const SizedBox(width: TSizes.spaceBtwItems / 2), Text('Add to Cart',style: Theme.of(context).textTheme.labelLarge,)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
