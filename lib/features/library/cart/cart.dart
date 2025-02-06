import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../home_menu.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../../../utils/loader/animated_loader.dart';
import '../../wishlist/payments/payment-page.dart';
import 'cart_controller.dart';
import 'widgets/cart_items.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final controller = CartController.instance;
    final cartItems = controller.cartItems;
    return Scaffold(
      backgroundColor: THelperFunctions.isDarkMode(context)?TColors.black:TColors.primaryBackground,
      /// -- AppBar
      appBar: TAppBar( color: THelperFunctions.isDarkMode(context)
       ? TColors.black
          : TColors.primaryBackground,
        showBackArrow: true, title: Text('Cart', style: Theme.of(context).textTheme.headlineSmall), padding: 0,),
      body: Obx(() {
        /// Nothing Found Widget
        final emptyWidget = TAnimationLoaderWidget(
          text: 'Whoops! Cart is EMPTY.',
          animation: TImages.noBooks,
          showAction: true,
          actionText: 'Let\'s fill it',
          onActionPressed: () => Get.off(() => const HomeMenu()),
        );

        /// Cart Items
        return cartItems.isEmpty
            ? emptyWidget
            : const SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0,vertical: 0),

                  /// -- Items in Cart
                  child: TCartItems(),
                ),
              );
      }),

      /// -- Checkout Button
      bottomNavigationBar: Obx(
        () {
          return cartItems.isNotEmpty
              ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace-16,vertical: 18),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Get.to(() =>  PaymentPage(title: '', bookID: '', bookUrl: 'https://firebasestorage.googleapis.com/v0/b/rabit-store.appspot.com/o/books%2FPAUKWA.webp?alt=media&token=da780c91-74ea-4e6b-84fe-e7846a2be0c5', author:'' , price: '',items: cartItems,)),
                      child: Obx(() => Text('Checkout ${controller.totalCartPrice.value}')),
                    ),
                  ),
                )
              : const SizedBox();
        },
      ),
    );
  }
}
