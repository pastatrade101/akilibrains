
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:trade101/features/library/pages/pdf_view.dart';




import '../../../common/widgets/appbar/appbar.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import 'package:blur/blur.dart';


import '../../../utils/helpers/helper_functions.dart';
import '../../wishlist/payments/payment-page.dart';
import '../cart/bottom_add_to_cart_widget.dart';
import '../models/book_model.dart';
import '../widgets/favourite_icon.dart';
import '../widgets/price-format.dart';
import '../widgets/profile_icon.dart';

class BookDetail extends StatelessWidget {
  const BookDetail({super.key, required this.book});

  final BookModel book;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: THelperFunctions.isDarkMode(context)
          ? TColors.black
          : TColors.primaryBackground,
      appBar: TAppBar(
        color: THelperFunctions.isDarkMode(context)
            ? TColors.black
            : TColors.primaryBackground,
        centerTitle: true,
        padding: 0,
        title: const Text('Book Detail'),
        showBackArrow: true,
        actions: [FavouriteIcon(bookID: book.id)],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            children: [
              CachedNetworkImage(
                width: 1000,
                height: 300,
                imageUrl: book.image,
                fit: BoxFit.cover,
              ).blurred(
                blurColor: Colors.black,
                colorOpacity: 0.1,
                borderRadius:
                    const BorderRadius.horizontal(right: Radius.circular(0)),
                blur: 20,
                overlay: ClipRRect(borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    width: 155,
                    height: THelperFunctions.screenHeight() * 0.3,
                    imageUrl: book.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: TSizes.defaultSpace - 6),
                child: Column(
                  children: [
                    const SizedBox(
                      height: TSizes.spaceBtwInputFields,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          child: SizedBox(
                            width: THelperFunctions.screenWidth() * 0.7,
                            child: Text(
                              book.bookName,
                              style: Theme.of(context).textTheme.headlineSmall,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        BookPriceText(
                            price: book.price,
                            maxLines: 1,
                            currencySign: 'TZS '),
                      ],
                    ),
                    const SizedBox(
                      height: TSizes.sm,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: TSizes.sm,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const ProfileIcon(),
                                const SizedBox(
                                  width: TSizes.sm,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      book.author,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                              color: THelperFunctions
                                                      .isDarkMode(context)
                                                  ? TColors.primaryBackground
                                                  : TColors.darkerGrey),
                                    ),
                                    const SizedBox(
                                      width: TSizes.sm,
                                    ),
                                    Text(
                                      'Author',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                              color:
                                                  THelperFunctions.isDarkMode(
                                                          context)
                                                      ? TColors.white
                                                          .withOpacity(0.5)
                                                      : TColors.black
                                                          .withOpacity(0.5)),
                                    )
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(
                              height: TSizes.sm,
                            ),
                            // const FiveStarRating(
                            //   glowRadius: 2,
                            //   itemSize: 20,
                            // )
                          ],
                        ),
                        TBottomAddToCart(book: book),
                      ],
                    ),

                    const SizedBox(
                      height: TSizes.sm,
                    ),
                    const SizedBox(
                      height: TSizes.md,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    side: const BorderSide(
                                        color: TColors.primary)),
                                onPressed: () {
                                  Get.to(PdfView(
                                    pdfUrl: book.bookUrl,
                                    title: book.bookName,
                                    imageUrl: book.image,
                                    author: book.author,
                                    price: book.price,
                                    bookID: book.id,
                                  ));
                                },
                                child:  Text('Read Summary',style: Theme.of(context).textTheme.titleSmall!.copyWith(color: THelperFunctions.isDarkMode(context)?TColors.light:TColors.primary),)),
                          ),
                        ),
                        const SizedBox(
                          width: TSizes.md,
                        ),
                        Expanded(
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: TColors.primary,
                                    side: const BorderSide(
                                        color: TColors.primary)),
                                onPressed: () {
                                  Get.to(PaymentPage(
                                    title: book.bookName,
                                    bookUrl: book.image,
                                    author: book.author,
                                    price: book.price,
                                    bookID: book.id,
                                    items: [],
                                  ));
                                },
                                child: const Text('Buy Now')),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: TSizes.md,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
