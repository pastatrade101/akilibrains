

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:trade101/features/authentication/personalization/screens/profile/profile.dart';
import 'package:trade101/utils/constants/colors.dart';
import 'package:trade101/utils/helpers/helper_functions.dart';


import 'features/authentication/personalization/screens/setting/settings.dart';
import 'features/cryptocurrency_data/screens/global_cryptocurrency_data.dart';
import 'features/library/books/books.dart';
import 'features/library/home.dart';
import 'features/wishlist/screens/bought_books.dart';
import 'features/wishlist/screens/wishlist.dart';



class HomeMenu extends StatelessWidget {
  const HomeMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AppScreenController());
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          animationDuration: const Duration(seconds: 3),
          selectedIndex: controller.selectedMenu.value,
          backgroundColor: THelperFunctions.isDarkMode(context) ? TColors.black : Colors.white,
          elevation: 0,
          indicatorColor: THelperFunctions.isDarkMode(context) ? TColors.white.withOpacity(0.1) : TColors.accent.withOpacity(0.1),
          onDestinationSelected: (index) => controller.selectedMenu.value = index,
          destinations:  [
            NavigationDestination(icon: Icon(Iconsax.home,color: controller.selectedMenu.value==0&&THelperFunctions.isDarkMode(context)?TColors.accent: THelperFunctions.isDarkMode(context)? TColors.light:TColors.darkGrey), label: 'Home'),
            NavigationDestination(icon: Icon(Iconsax.book_1,color: controller.selectedMenu.value==1&&THelperFunctions.isDarkMode(context)?TColors.accent: THelperFunctions.isDarkMode(context)? TColors.light:TColors.darkGrey), label: 'Library'),
            NavigationDestination(icon: Icon(Iconsax.archive_1,color: controller.selectedMenu.value==2&&THelperFunctions.isDarkMode(context)?TColors.accent: THelperFunctions.isDarkMode(context)? TColors.light:TColors.darkGrey), label: 'My books'),
            NavigationDestination(icon: Icon(Iconsax.lovely,color: controller.selectedMenu.value==3 && THelperFunctions.isDarkMode(context)?TColors.accent: THelperFunctions.isDarkMode(context)? TColors.light:TColors.darkGrey), label: 'Favourite'),
            NavigationDestination(icon: Icon(Iconsax.user,color: controller.selectedMenu.value==4 && THelperFunctions.isDarkMode(context)?TColors.accent: THelperFunctions.isDarkMode(context)? TColors.light:TColors.darkGrey), label: 'Profile'),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedMenu.value]),
    );
  }
}

class AppScreenController extends GetxController {
  static AppScreenController get instance => Get.find();

  final Rx<int> selectedMenu = 0.obs;

  final screens = [ const HomeScreen(), const Books(), PaidBooksPage(),const FavouriteScreen(),  const ProfileScreen()];
}
