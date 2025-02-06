import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';

import '../../../common/widgets/icons/t_circular_icon.dart';
import '../../../utils/constants/colors.dart';
import '../../wishlist/controller/favourite_controller.dart';

class FavouriteIcon extends StatelessWidget {

   const FavouriteIcon({
    super.key, required this.bookID,
  });
   final String bookID;
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FavouritesController());
    return Obx(
      ()=>TCircularIcon(
        height: 32,
        width: 32,
        icon: controller.isFavourite(bookID) ? Iconsax.heart5 : Iconsax.heart ,
        color:  controller.isFavourite(bookID) ? TColors.error : null,
        onPressed: () => {controller.toggleFavoriteBooks(bookID)},
      ),
    );
  }
}