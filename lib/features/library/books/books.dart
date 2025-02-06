import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trade101/features/library/delay_display.dart';

import '../../../common/widgets/appbar/appbar.dart';
import '../../../common/widgets/appbar/tabbar.dart';
import '../../../common/widgets/shimmer/shimmer_effect.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../controller/books_controller.dart';
import '../controller/categories_controller.dart';
import '../pages/book_detail.dart';
import '../widgets/new_books_widget.dart';


class Books extends StatelessWidget {
  const Books({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BookController());

    final books  = controller.allBooks;


    final categoriesController = Get.put(CategoryController());

    final categories = categoriesController.allCategories;
    const Duration initialDelay = Duration(milliseconds: 500);


    return DefaultTabController(
      length: categories.length,
      child: Scaffold(backgroundColor: THelperFunctions.isDarkMode(context)?TColors.black:TColors.primaryBackground,
        appBar: TAppBar(color: THelperFunctions.isDarkMode(context)
            ? TColors.black
            : TColors.primaryBackground,
          centerTitle: true,
          title: Text.rich(TextSpan(children: [
            TextSpan(
                text: 'Store',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(color:THelperFunctions.isDarkMode(context)?TColors.complementary: TColors.primary)),
            const TextSpan(text: ' - '),
            TextSpan(
                text: 'Books', style: Theme.of(context).textTheme.headlineSmall)
          ])),
          padding: 0,
        ),
          body:
          DelayedDisplay(
            fadeIn: true,
              delay: Duration(milliseconds: initialDelay.inMilliseconds + 200),
            slidingBeginOffset: const Offset(0.5, 0),
            child: NestedScrollView(


              /// -- Header
              headerSliverBuilder: (_, innerBoxIsScrolled) {
                return [
                  SliverAppBar(foregroundColor: TColors.complementary,
                    // flexibleSpace: const Padding(
                    //   padding: EdgeInsets.only(top: 8),
                    //   child: TSearchContainer(text: 'Search books'),
                    // ),

                    expandedHeight: 0,


                    pinned: true,
                    floating: true,
                    // Space between Appbar and TabBar. WithIn this height we have added [Search bar] and [Featured brands]


                    backgroundColor: THelperFunctions.isDarkMode(context) ? TColors.black : TColors.white,

                    /// -- Search & Featured Store
                    ///
                    /// -- TABS
                    bottom:  TTabBar(  tabs: categories.map((e) => Tab(child: Text(e.categoryName))).toList()),
                  )
                ];
              },

              /// -- TabBar Views
              body: DelayedDisplay(
                delay: Duration(milliseconds: initialDelay.inMilliseconds + 200),
                slidingBeginOffset: const Offset(0.5, 0),fadeIn: true,

                child: TabBarView(
                  children:
                     categories.map((category) => Obx(()=> controller.isLoading.value? TShimmerEffect(color: TColors.grey, width: THelperFunctions.screenWidth(), height: 100):
                       Padding(
                             padding: const EdgeInsets.only(top: 8),
                             child: ListView.builder(
                   physics: const NeverScrollableScrollPhysics(),
                   scrollDirection: Axis.vertical,
                   shrinkWrap: true,
                   itemCount: books.where((book) => (book.category == category.categoryName)).toList().length

                       ,
                   itemBuilder: (context, index) {
                     final categoryBooks = books.where((book) => (book.category==category.categoryName)).toList()[index];

                     return DelayedDisplay(   delay: Duration(milliseconds: initialDelay.inMilliseconds + 200),slidingBeginOffset: const Offset(0.3,1),fadeIn: true,
                       child: Padding(
                         padding: const EdgeInsets.only(bottom: TSizes.sm),
                         child: NewBookWidget(
                           onTap: () {
                             Get.to(BookDetail(book: categoryBooks));
                           },
                           price: categoryBooks.price,
                           image: categoryBooks.image,
                           bookName: categoryBooks.bookName,
                           author: categoryBooks.author, bookId: categoryBooks.id,
                         ),
                       ),
                     );
                   }),
                       ),
                     )).toList(),
                ),
              ),
            ),
          ),
      ),
    );
  }

}
