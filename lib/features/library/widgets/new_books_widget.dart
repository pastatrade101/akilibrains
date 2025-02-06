import 'package:flutter/material.dart';
import 'horizontal_book.dart';
class NewBookWidget extends StatelessWidget {
  const NewBookWidget({
    super.key, required this.image, required this.author, required this.bookName, required this.price, required this.onTap, required this.bookId,
  });
  final String image;
  final String author,bookName;
  final String price,bookId;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          HorizontalBookWidget(
            price: price,
            image: image,
            bookName: bookName,
            author: author, bookID: bookId,
          ),



        ],
      ),
    );
  }
}
