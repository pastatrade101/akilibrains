import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trade101/features/library/delay_display.dart';
import 'package:trade101/features/wishlist/payments/select_payment.dart';

import '../../../azampay_api.dart';
import '../../../checkout_controller.dart';

import '../../../common/widgets/appbar/appbar.dart';
import '../../../data/repositories/authentication/authentication_repository.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../../../utils/validators/validation.dart';
import '../../library/cart/cart_controller.dart';
import '../../library/cart/cart_model.dart';

import '../../library/controller/order_controller.dart';
import '../../library/widgets/price-format.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({
    super.key,
    required this.title,
    required this.bookID,
    required this.bookUrl,
    required this.author,
    required this.price,
    this.items,
  });

  final String title;
  final List<CartItemModel>? items;
  final String bookUrl, author, price, bookID;

  @override
  Widget build(BuildContext context) {
    final controller = CartController.instance;
    const Duration initialDelay = Duration(milliseconds: 200);

    final cartPrice = controller.totalCartPrice.value.toString();
    Map<String, List<String>> arrayWithKeyExtraction = {
      'bookids': items!.map((item) => item.bookId).toList()
    };
    List<String>? bookIDs = arrayWithKeyExtraction['bookids'];
    print('This is the books IDS: $bookIDs');

    final CheckoutController checkoutController = Get.put(CheckoutController());
    final orderController = Get.put(OrderController());

    return Scaffold(
      backgroundColor: THelperFunctions.isDarkMode(context)
          ? TColors.black
          : TColors.primaryBackground,
      appBar: TAppBar(
        color: THelperFunctions.isDarkMode(context)
            ? TColors.black
            : TColors.primaryBackground,
        showBackArrow: true,
        padding: 0,
        title: const Text('Checkout page'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: TSizes.defaultSpace - 10, vertical: 8),
          child: Column(
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                if (items != null)
                  ...items!.map((item) {
                    return DelayedDisplay(
                        delay: Duration(milliseconds: initialDelay.inMilliseconds + 200),
                      child: Container(
                        margin: const EdgeInsets.only(
                            bottom: TSizes.spaceBtwItems - 8),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: TColors.accent,
                            ),
                            borderRadius: BorderRadius.circular(4),
                            color: TColors.accent.withOpacity(0.2)),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: CachedNetworkImage(
                              imageUrl: item.image.toString(),
                            ),
                          ),
                          title: Text(
                            item.title,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(fontSize: 14),
                          ),
                          subtitle: Text(item.author),
                          trailing: BookPriceText(
                              price: item.price.toString(), currencySign: 'TZS '),
                        ),
                      ),
                    );
                  }).toList(),
              ]),
              (bookID == '')
                  ? const SizedBox()
                  : DelayedDisplay(delay: Duration(milliseconds: initialDelay.inMilliseconds + 200),
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                            color: TColors.accent.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: TColors.accent)),
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: CachedNetworkImage(
                                width: 80,
                                height: 130,
                                imageUrl: bookUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              height: 130,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Author: ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                color: THelperFunctions
                                                        .isDarkMode(context)
                                                    ? TColors.primaryBackground
                                                    : TColors.darkerGrey
                                                        .withOpacity(0.6),
                                              ),
                                            ),
                                            TextSpan(
                                              text: author,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: THelperFunctions
                                                        .isDarkMode(context)
                                                    ? TColors.primaryBackground
                                                    : TColors.darkerGrey
                                                        .withOpacity(0.9),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: TSizes.sm,
                                      ),
                                      SizedBox(
                                        width:
                                            THelperFunctions.screenWidth() * .6,
                                        child: Text(
                                          title,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Price: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          color:
                                              THelperFunctions.isDarkMode(context)
                                                  ? TColors.primaryBackground
                                                  : TColors.darkerGrey
                                                      .withOpacity(0.6),
                                        ),
                                      ),
                                      BookPriceText(
                                        price: price,
                                        currencySign: 'TZS ',
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                  ),
              const SizedBox(
                height: TSizes.spaceBtwItems,
              ),
              DelayedDisplay(delay: Duration(milliseconds: initialDelay.inMilliseconds + 200), child: const PaymentOption()),
              // PayOptions(),

              const SizedBox(
                height: TSizes.spaceBtwItems,
              ),
              Form(
                key: checkoutController.checkOutFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DelayedDisplay(delay: Duration(milliseconds: initialDelay.inMilliseconds + 200),
                      child: TextFormField(
                        validator: (value) =>
                            TValidator.validatePhoneNumber(value),
                        controller: checkoutController.phoneNumberController,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: DelayedDisplay(delay: Duration(milliseconds: initialDelay.inMilliseconds + 200),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: TColors.primary),
                    onPressed: () async {
                      bool isValid = await checkoutController.checkOut();
                      if (isValid) {
                        String phoneNumber =
                            checkoutController.phoneNumberController.text;
                        String? accessToken = await AuthenticationRepository
                            .instance.authUser
                            ?.getIdToken();
                        String? azamToken = await generateAccessToken();
                        orderController.processOrder(
                            (price == '') ? cartPrice : price,
                            phoneNumber,
                            accessToken,
                            azamToken,
                            (bookID == '') ? bookIDs.toString() : bookID);
                      }
                    },
                    child: (bookID != '')
                        ? Text('Pay Now $price')
                        : Obx(() => Text(
                            'Pay Now ${controller.totalCartPrice.value.toString()}')),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
