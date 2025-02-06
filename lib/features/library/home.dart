import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:trade101/features/library/pages/book_detail.dart';
import 'package:trade101/features/library/pages/controllers/most_sold_book_controller.dart';
import 'package:trade101/features/library/widget.dart';
import 'package:trade101/features/library/widgets/categories.dart';
import 'package:trade101/features/library/widgets/favourite_icon.dart';
import 'package:trade101/features/library/widgets/most_sold_widget.dart';
import 'package:trade101/features/library/widgets/new_books_widget.dart';
import 'package:trade101/features/library/widgets/profile_name.dart';
import 'package:trade101/features/library/widgets/vertical_book.dart';
import 'package:trade101/utils/constants/image_strings.dart';
import 'package:upgrader/upgrader.dart';

import '../../common/widgets/appbar/appbar.dart';
import '../../common/widgets/custom_shapes/containers/circular_container.dart';
import '../../common/widgets/shimmer/cart_menu_icon/cart_menu_icon.dart';
import '../../common/widgets/shimmer/shimmer_effect.dart';
import '../../common/widgets/texts/section_heading.dart';
import '../../home_menu.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';

import '../../utils/device/get_pixel.dart';
import '../../utils/helpers/helper_functions.dart';
import '../authentication/personalization/controllers/user_controller.dart';
import '../authentication/personalization/screens/profile/profile.dart';
import '../authentication/personalization/screens/recommendation/recommendation.dart';
import '../authentication/personalization/screens/recommendation/recommendation_controller.dart';
import 'controller/books_controller.dart';
import 'controller/categories_controller.dart';
import 'delay_display.dart';
import 'models/book_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationController = Get.put(AppScreenController());

    final userController = Get.put(UserController());
    final controller = Get.put(BookController());
    final mostSoldBookController = Get.put(MostSoldBookController());
    final BookStoreController recommendedBookController =
        Get.put(BookStoreController());

    final categoryController = Get.put(CategoryController());

    final popularBooks = controller.popularBooks();
    final featuredBooks = controller.trendingBooks();
    const Duration initialDelay = Duration(milliseconds: 100);

    return UpgradeAlert(
      showReleaseNotes: false,
      showIgnore: false,
      dialogStyle: GetPlatform.isIOS
          ? UpgradeDialogStyle.cupertino
          : UpgradeDialogStyle.material,
      upgrader: Upgrader(



          ),
      child: Scaffold(
        backgroundColor: THelperFunctions.isDarkMode(context)
            ? TColors.black
            : TColors.primaryBackground,
        appBar: TAppBar(
          color: THelperFunctions.isDarkMode(context)
              ? TColors.black
              : TColors.primaryBackground,
          padding: 0,
          showBackArrow: false,
          title: Row(
            children: [
              // ---Profile Icon
              GestureDetector(
                onTap: () => Get.to(const ProfileScreen()),
                child: TCircularContainer(
                    width: 40,
                    height: 40,
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                    borderColor: TColors.accent,
                    showBorder: true,
                    child: Obx(() {
                      if (userController.profileLoading.value) {
                        return const TShimmerEffect(width: 40, height: 15);
                      } else {
                        final networkImage =
                            userController.user.value.profilePicture;
                        final image = networkImage.isNotEmpty
                            ? networkImage
                            : const Icon(Iconsax.profile_circle);
                        if (userController.imageUploading.value) {
                          return DelayedDisplay(
                            delay: Duration(
                                milliseconds:
                                    initialDelay.inMilliseconds + 400),
                            child: const TShimmerEffect(
                              width: 55,
                              height: 55,
                              radius: 55,
                            ),
                          );
                        } else {
                          return networkImage.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(40),
                                  child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      progressIndicatorBuilder:
                                          (context, url, downloadProgress) =>
                                              const TShimmerEffect(
                                                width: 55,
                                                height: 55,
                                                radius: 55,
                                              ),
                                      imageUrl: networkImage),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(40),
                                  child: const Icon(Iconsax.profile_circle),
                                );
                        }
                      }
                    })),
              ),
              const SizedBox(
                width: TSizes.sm,
              ),

              // -----Profile name
              Obx(() {
                if (userController.profileLoading.value) {
                  return DelayedDisplay(
                      delay: Duration(
                          milliseconds: initialDelay.inMilliseconds + 400),
                      child: const TShimmerEffect(width: 80, height: 15));
                } else {
                  return DelayedDisplay(
                    delay: Duration(
                        milliseconds: initialDelay.inMilliseconds + 400),
                    child: ProfileName(
                      color: THelperFunctions.isDarkMode(context)
                          ? TColors.primaryBackground
                          : TColors.darkerGrey,
                      heading: userController.user.value.fullName,
                      name: 'Welcome',
                    ),
                  );
                }
              })
            ],
          ),
          actions: [
            TCartCounterIcon(
                iconColor: THelperFunctions.isDarkMode(context)
                    ? TColors.white
                    : TColors.black,
                counterBgColor: TColors.black,
                counterTextColor: TColors.white)
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: TSizes.defaultSpace - 8),
                child: DelayedDisplay(
                  delay:
                      Duration(milliseconds: initialDelay.inMilliseconds + 400),
                  child: TSectionHeading(
                    onPressed: () {
                      navigationController.selectedMenu.value = 1;
                    },
                    showActionButton: true,
                    title: 'Featured Categories',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: TSizes.defaultSpace - 8),
                child: Obx(() => categoryController.isLoading.value
                    ? TShimmerEffect(
                        width: THelperFunctions.screenWidth(),
                        height: 50,
                        color: TColors.darkerGrey.withOpacity(0.7),
                      )
                    : GestureDetector(
                        onTap: () {},
                        child: DelayedDisplay(
                          delay: Duration(
                              milliseconds: initialDelay.inMilliseconds + 400),
                          child: THeaderCategories(
                              categoryList:
                                  categoryController.featuredCategories),
                        ),
                      )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: TSizes.defaultSpace - 8),
                child: TSectionHeading(
                    onPressed: () {
                      navigationController.selectedMenu.value = 1;
                    },
                    title: 'Featured Books'),
              ),
              const SizedBox(
                height: TSizes.sm,
              ),
              Column(
                children: [
                  SizedBox(
                    height: 310,
                    child: Padding(
                        padding: const EdgeInsets.only(left: 0),
                        child: Obx(
                          () => controller.isLoading.value
                              ? TShimmerEffect(
                                  width: THelperFunctions.screenWidth(),
                                  height: 200)
                              : Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: DelayedDisplay(
                                    delay: Duration(
                                        milliseconds:
                                            initialDelay.inMilliseconds + 400),
                                    child: ListView.builder(
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemCount: featuredBooks.length,
                                      itemBuilder: (context, index) {
                                        final bookData = featuredBooks[index];
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              right: TSizes.sm),
                                          child: VerticalBookCard(
                                            onTap: () {
                                              Get.to(BookDetail(
                                                book: bookData,
                                              ));
                                            },
                                            author: bookData.author,
                                            bookName: bookData.bookName,
                                            image: bookData.image,
                                            price: bookData.price,
                                            bookID: bookData.id,
                                            child: FavouriteIcon(
                                                bookID: bookData.id),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                        )),
                  ),
                ].animate(interval: 100.ms).fadeIn(duration: 200.ms),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: TSizes.defaultSpace - 8, vertical: TSizes.sm),
                child: DelayedDisplay(
                  delay:
                      Duration(milliseconds: initialDelay.inMilliseconds + 400),
                  child: TSectionHeading(
                      onPressed: () {
                        navigationController.selectedMenu.value = 1;
                      },
                      title: 'Best Selling Books'),
                ),
              ),
              SizedBox(
                height: 310,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: FutureBuilder<List<BookModel>>(
                    future: mostSoldBookController.fetchMostSoldBooks(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return TShimmerEffect(
                          width: THelperFunctions.screenWidth(),
                          height: 200,
                        );
                      } else if (snapshot.hasError) {
                        return const Center(child: Text(''));
                      } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                        return const Center(child: Text(''));
                      } else {
                        return DelayedDisplay(
                            delay: Duration(
                                milliseconds:
                                    initialDelay.inMilliseconds + 400),
                            child: MostSoldBooksList(books: snapshot.data!));
                      }
                    },
                  ),
                ),
              ),
              DelayedDisplay(
                  delay:
                      Duration(milliseconds: initialDelay.inMilliseconds + 400),
                  child: RecommendationBooksWidget(
                      controller: recommendedBookController)),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: TSizes.defaultSpace - 8, vertical: TSizes.sm),
                child: TSectionHeading(
                    onPressed: () {
                      navigationController.selectedMenu.value = 1;
                    },
                    title: 'Popular Books'),
              ),
              Obx(
                () => controller.isLoading.value
                    ? DelayedDisplay(
                        delay: Duration(
                            milliseconds: initialDelay.inMilliseconds + 400),
                        child: TShimmerEffect(
                            width: THelperFunctions.screenWidth(), height: 100),
                      )
                    : DelayedDisplay(
                        delay: Duration(
                            milliseconds: initialDelay.inMilliseconds + 400),
                        slidingBeginOffset: const Offset(0.5, 0),
                        child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: popularBooks.length,
                            itemBuilder: (context, index) {
                              final popularBooksData = popularBooks[index];

                              return Padding(
                                padding:
                                    const EdgeInsets.only(bottom: TSizes.sm),
                                child: NewBookWidget(
                                  onTap: () {
                                    Get.to(BookDetail(book: popularBooksData));
                                  },
                                  price: popularBooksData.price,
                                  image: popularBooksData.image,
                                  bookName: popularBooksData.bookName,
                                  author: popularBooksData.author,
                                  bookId: popularBooksData.id,
                                ),
                              );
                            }),
                      ),
              ),
            ].animate(interval: 100.ms).fadeIn(duration: 200.ms),
          ),
        ),
      ),
    );
  }
}

Widget getCustomFont(String text, double fontSize, Color fontColor, int maxLine,
    {String fontFamily = Constant.fontsFamily,
    TextOverflow overflow = TextOverflow.ellipsis,
    TextDecoration decoration = TextDecoration.none,
    FontWeight fontWeight = FontWeight.normal,
    TextAlign textAlign = TextAlign.start,
    txtHeight,
    bool horFactor = false}) {
  return Text(
    text,
    overflow: overflow,
    style: TextStyle(
        decoration: decoration,
        fontSize: fontSize,
        fontStyle: FontStyle.normal,
        color: fontColor,
        fontFamily: Constant.fontsFamily,
        height: txtHeight,
        fontWeight: fontWeight),
    maxLines: maxLine,
    softWrap: true,
    textAlign: textAlign,
    textScaleFactor: FetchPixels.getTextScale(horFactor: horFactor),
  );
}
