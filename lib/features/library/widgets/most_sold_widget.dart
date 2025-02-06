
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:trade101/features/library/widgets/vertical_book.dart';


import '../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../utils/constants/sizes.dart';
import '../models/book_model.dart';
import '../pages/book_detail.dart';


class MostSoldBooksList extends StatelessWidget {
  final List<BookModel> books;

  const MostSoldBooksList({Key? key, required this.books}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return Padding(
          padding: const EdgeInsets.only(right: TSizes.sm),
          child: VerticalBookCard(
            onTap: () {
              Get.to(BookDetail(
                book: book,
              ));
            },
            author: book.author,
            bookName: book.bookName,
            image: book.image,
            price: book.price,
            bookID: book.id,
            child: TRoundedContainer(radius: 4, backgroundColor: Colors.white.withOpacity(0.9), padding: const EdgeInsets.symmetric(horizontal: 4,vertical: 4), child: Text('${book.count}+ Sold',style: Theme.of(context).textTheme.bodyLarge!.copyWith(color:Colors.red,fontSize: 10),)),
          ),
        );
      },
    );
  }
}