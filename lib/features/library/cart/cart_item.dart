
import 'package:flutter/material.dart';



import 'cart_horizontal_book_widget.dart';
import 'cart_model.dart';

class TCartItem extends StatelessWidget {
  const TCartItem({
    super.key,
    required this.item,
  });

  final CartItemModel item;

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        /// 1 - Image
        ///
        CartHorizontalBookWidget(price: item.price.toString(),image: item.image.toString(),bookName: item.title,bookID: item.bookId,author: item.author),

        /// 2 - Title, Price, & Size
      ],
    );
  }
}
