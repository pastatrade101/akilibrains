import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:trade101/features/library/delay_display.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/icons/t_circular_icon.dart';
import '../../../../common/widgets/layouts/grid_layout.dart';

import '../../../../home_menu.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/device/device_utility.dart';
import '../../../utils/cloud_helper/cloud_helper_function.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../../../utils/loader/animated_loader.dart';
import '../../../utils/loader/vertical_book_shimmer.dart';
import '../../library/pages/book_detail.dart';
import '../../library/widgets/favourite_icon.dart';
import '../../library/widgets/vertical_book.dart';
import '../controller/favourite_controller.dart';


class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final axisCount = TDeviceUtils.getScreenWidth(context);
    const Duration initialDelay = Duration(milliseconds: 100);
    return PopScope(
      canPop: false,
      // Intercept the back button press and redirect to Home Screen
      onPopInvoked: (value) async => Get.offAll(const HomeMenu()),
      child: Scaffold(
        backgroundColor: THelperFunctions.isDarkMode(context)?TColors.black:TColors.primaryBackground,

        appBar: TAppBar(
          title: Text('Wishlist', style: Theme.of(context).textTheme.headlineMedium),
          actions: [TCircularIcon(icon: Iconsax.add, onPressed: () {})], padding: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              children: [

                /// Products Grid
                Obx(() {
                  return FutureBuilder(
                    future: FavouritesController.instance.favoriteBooks(),
                    builder: (_, snapshot) {
                      /// Nothing Found Widget
                      final emptyWidget = TAnimationLoaderWidget(
                        text: 'Whoops! Wishlist is Empty...',
                        animation: TImages.noBooks,
                        showAction: true,
                        actionText: 'Let\'s add some',
                        onActionPressed: () => Get.off(() => const HomeMenu()),
                      );
                      const loader = TVerticalProductShimmer(itemCount: 6);
                      final widget = TCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot, loader: loader, nothingFound: emptyWidget);
                      if (widget != null) return widget;

                      final books = snapshot.data!;
                      return DelayedDisplay(
                        delay: Duration(milliseconds: initialDelay.inMilliseconds + 400),
                        child: TGridLayout(
                          itemCount: books.length,
                          itemBuilder: (_, index) =>  VerticalBookCard(
                            onTap: () {
                              Get.to(BookDetail(
                                book: books[index],
                              ));
                            },
                            author: books[index].author,
                            bookName: books[index].bookName,
                            image: books[index].image,
                            price: books[index].price, bookID: books[index].id, child: FavouriteIcon(bookID:books[index].id ),
                          ), crossAxisCount: (axisCount >420)?4:2,
                        ),
                      );
                    },
                  );
                }),
                SizedBox(height: TDeviceUtils.getBottomNavigationBarHeight() + TSizes.defaultSpace),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
