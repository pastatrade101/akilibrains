
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trade101/features/authentication/personalization/screens/recommendation/recommendation_controller.dart';


import '../../../../../common/widgets/shimmer/shimmer_effect.dart';
import '../../../../../common/widgets/texts/section_heading.dart';
import '../../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../../library/models/book_model.dart';
import '../../../../library/pages/book_detail.dart';
import '../../../../library/widgets/vertical_book.dart';







class RecommendationBooksWidget extends StatelessWidget {
  const RecommendationBooksWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final BookStoreController controller;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, List<BookModel>>>(
      future: controller.fetchBooksForUserOrders(AuthenticationRepository.instance.getUserID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return TShimmerEffect(
              width: THelperFunctions.screenWidth(),
              height: 200);
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (snapshot.hasData) {
          final booksByCategory = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: booksByCategory.keys.map((category) {
              final books = booksByCategory[category]!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       const TSectionHeading(title: 'Recommended For You'),
                        Text(category,style: Theme.of(context).textTheme.titleLarge!.copyWith(color: THelperFunctions.isDarkMode(context)?TColors.accent:TColors.accent,fontWeight: FontWeight.w500),),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 310,
                    child: Padding(padding: const EdgeInsets.all(5),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: books.length,
                        itemBuilder: (context, index) {
                          final book = books[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: TSizes.sm),
                            child: VerticalBookCard(
                              image: book.image,
                              author: book.author,
                              price: book.price,
                              bookName: book.bookName,
                              bookID: book.id,
                              onTap: () {
                                Get.to(BookDetail(book: book));
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              );
            }).toList(),
          );
        } else {
          return const SizedBox(); // Return an empty container if there is no data
        }
      },
    );
  }
}

