
import 'package:flutter/material.dart';
import 'package:trade101/features/library/widgets/price_widget.dart';



import '../../../common/images/t_rounded_image.dart';
import '../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../utils/constants/colors.dart';

import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';
import 'author_widget.dart';
import 'five_star_widget.dart';
class AllBooksWidget extends StatelessWidget {
  const AllBooksWidget({
    super.key,
    required this.image,
    required this.price,
    required this.author,
    required this.bookName, required this.onTap,
  });

  final String image;
  final String price;
  final String  author, bookName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(margin: const EdgeInsets.only(top: TSizes.xs),
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace - 8),
          child: TRoundedContainer(
            backgroundColor: THelperFunctions.isDarkMode(context)?TColors.dark:TColors.white,
            radius: 4,
            padding: const EdgeInsets.symmetric(
                horizontal: TSizes.md - 6, vertical: TSizes.md - 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     TRoundedImage(
                        height: 70,
                        width: 50,
                        fit: BoxFit.cover,
                        borderRadius: 4,
                        imageUrl: image),
                    const SizedBox(
                      width: TSizes.md,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: THelperFunctions.screenWidth()*0.5,
                          child: Text(
                            bookName,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        AuthorWidget(author: author),
                        const SizedBox(
                          height: TSizes.sm,
                        ),
                        const FiveStarRating(itemSize: 20,initialRating: 4,glowRadius: 2,)
                      ],
                    ),
                  ],
                ),
                PriceWidget(price: '$price')
              ],
            ),
          ),
        ),
      ),
    );
  }
}