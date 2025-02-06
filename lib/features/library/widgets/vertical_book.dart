
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:trade101/features/library/widgets/price-format.dart';
import '../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';
import 'author_widget.dart';


class VerticalBookCard extends StatelessWidget {
  const VerticalBookCard({
    super.key,
    required this.image,
    required this.author,
    required this.bookName,
    required this.onTap,
    required this.price, required this.bookID, this.child,
  });

  final String image;
  final String author, bookName,bookID;
  final String price;
  final VoidCallback onTap;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: TRoundedContainer(showBorder: true,borderColor:THelperFunctions.isDarkMode(context)? TColors.accent.withOpacity(0.1):TColors.accent.withOpacity(0.2),
        width: 160,

        padding: const EdgeInsets.all(TSizes.xs),
        backgroundColor:
        THelperFunctions.isDarkMode(context) ? TColors.dark : TColors.white,
        child: Stack(
          children: [
            Positioned(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      width: 155,
                      height: 230,
                      imageUrl: image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: TSizes.md,
                      ),
                      // Book Title

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 140,
                                child: Text(
                                  bookName,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(
                                height: TSizes.xs - 4,
                              ),
                              SizedBox(
                                  width: 150,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      AuthorWidget(author: author),
                                      BookPriceText(price: price,currencySign: 'TZS ')
                                    ],
                                  ))
                            ],
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            Positioned(right: 8,top: 8,
              child: child??const Text(''),
            ),
          ],
        ),
      ),
    );
  }
}


