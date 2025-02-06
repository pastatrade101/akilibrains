
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:trade101/features/library/widgets/price-format.dart';


import '../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../utils/constants/colors.dart';

import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';
import 'favourite_icon.dart';

class HorizontalBookWidget extends StatelessWidget {
  const HorizontalBookWidget({
    super.key,
    required this.image,
    required this.price,
    required this.author,
    required this.bookName, required this.bookID,
  });

  final String image;
  final String price, author, bookName,bookID;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace - 8),
      child: TRoundedContainer(
        backgroundColor: THelperFunctions.isDarkMode(context)?TColors.dark:TColors.white,
        radius: 4,
        padding: const EdgeInsets.symmetric(
            horizontal: TSizes.md - 12, vertical: TSizes.md - 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: CachedNetworkImage(
                    width: 50,
                    height: 70,
                    imageUrl: image,
                    fit: BoxFit.cover,
                  ),
                ),
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
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(author,style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: THelperFunctions.isDarkMode(context)?TColors.accent:TColors.darkGrey,fontSize: 12),),
                    const SizedBox(
                      height: TSizes.sm,
                    ),
                    // const FiveStarRating(itemSize: 20,initialRating: 4,glowRadius: 2,)
                  ],
                ),
              ],
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [ FavouriteIcon(bookID: bookID ),const SizedBox(height: 5,),BookPriceText(price: price,currencySign: 'TZS ',)],)
          ],
        ),
      ),
    );
  }
}