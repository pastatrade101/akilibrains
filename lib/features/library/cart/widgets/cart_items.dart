import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../../common/widgets/icons/t_circular_icon.dart';
import '../cart_controller.dart';
import '../cart_item.dart';


class TCartItems extends StatelessWidget {
  const TCartItems({
    super.key,
    this.showAddRemoveButtons = true,
  });

  final bool showAddRemoveButtons;

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;
    final cartItems = cartController.cartItems;
    const showAddIcon  =false;
    return Obx(
      () {
        return ListView.separated(
          shrinkWrap: true,
          itemCount: cartItems.length,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => const SizedBox(height: TSizes.spaceBtwSections-16),
          itemBuilder: (context, index) {
            return Obx(
              () {
                final item = cartItems[index];
                return Column(
                  children: [
                    /// -- Cart Items
                    Stack(children: [TCartItem(item: item), if (showAddRemoveButtons)
                      Positioned(top: 10,right: -10,
                        child: TProductQuantityWithAddRemoveButton(showAddIcon: showAddIcon,
                          width: 32,
                          height: 32,
                          iconSize: TSizes.md,
                          addBackgroundColor: TColors.primary,
                          removeForegroundColor: THelperFunctions.isDarkMode(context) ? TColors.white : TColors.white,
                          removeBackgroundColor: THelperFunctions.isDarkMode(context) ? Colors.red.withOpacity(0.5) : Colors.red.withOpacity(0.8),
                          quantity: item.quantity,

                          remove: () => cartController.removeOneFromCart(item),
                        ),
                      )],),


                    /// -- Add Remove Buttons and Price Total

                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}


class TProductQuantityWithAddRemoveButton extends StatelessWidget {
  const TProductQuantityWithAddRemoveButton({
    super.key,
     this.add,
    this.width = 40,
    this.height = 40,
    this.iconSize,
    required this.remove,
    required this.quantity,
    this.addBackgroundColor = TColors.secondary,
    this.removeBackgroundColor = Colors.red,
    this.addForegroundColor = TColors.white,
    this.removeForegroundColor = TColors.white, required this.showAddIcon,
  });

  final VoidCallback? add, remove;
  final int quantity;
  final bool showAddIcon;
  final double width, height;
  final double? iconSize;
  final Color addBackgroundColor, removeBackgroundColor;
  final Color addForegroundColor, removeForegroundColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TCircularIcon(
          icon: Iconsax.minus,
          onPressed: remove,
          width: width,
          height: height,
          size: iconSize,
          color: removeForegroundColor,
          backgroundColor: removeBackgroundColor,
        ),
        const SizedBox(width: TSizes.spaceBtwItems),
        (showAddIcon)?Text(quantity.toString(), style: Theme.of(context).textTheme.titleSmall):const SizedBox(),
        const SizedBox(width: TSizes.spaceBtwItems),
        (showAddIcon)?AddCartCircleButton(add: add, width: width, height: height, iconSize: iconSize, addForegroundColor: addForegroundColor, addBackgroundColor: addBackgroundColor):const SizedBox(),
      ],
    );
  }
}

class AddCartCircleButton extends StatelessWidget {
  const AddCartCircleButton({
    super.key,
    required this.add,
    required this.width,
    required this.height,
    required this.iconSize,
    required this.addForegroundColor,
    required this.addBackgroundColor,
  });

  final VoidCallback? add;
  final double width;
  final double height;
  final double? iconSize;
  final Color addForegroundColor;
  final Color addBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return TCircularIcon(
      icon: Iconsax.add,
      onPressed: add,
      width: width,
      height: height,
      size: iconSize,
      color: addForegroundColor,
      backgroundColor: addBackgroundColor,
    );
  }
}
