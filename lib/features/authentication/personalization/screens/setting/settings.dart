import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../common/images/t_rounded_image.dart';
import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../common/widgets/custom_shapes/containers/circular_container.dart';
import '../../../../../common/widgets/custom_shapes/containers/primary_header_container.dart';
import '../../../../../common/widgets/list_tiles/settings_menu_tile.dart';
import '../../../../../common/widgets/shimmer/shimmer_effect.dart';
import '../../../../../common/widgets/texts/section_heading.dart';
import '../../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../../utils/constants/colors.dart';
import 'package:http/http.dart' as http;
import '../../../../../utils/constants/sizes.dart';

import '../../../../cryptocurrency_data/controller/notification_controller_fcm/notification_controller_fcm.dart';
import '../../../../library/widgets/profile_name.dart';
import '../../controllers/setting_controller.dart';
import '../../controllers/user_controller.dart';

import '../profile/profile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userController = UserController.instance;
    final settingController = SettingController.instance;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// -- Header
            TPrimaryHeaderContainer(
              child: Column(
                children: [
                  /// AppBar
                  TAppBar(
                    title: Text('Account',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .apply(color: TColors.white)),
                    padding: 0,
                  ),

                  /// User Profile Card
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: TSizes.defaultSpace - 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              // ---Profile Icon
                              TCircularContainer(
                                  width: 60,
                                  height: 60,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 2),
                                  borderColor: TColors.primary,
                                  showBorder: true,
                                  child: Obx(() {
                                    if (userController.profileLoading.value) {
                                      return const TShimmerEffect(
                                          width: 40, height: 15);
                                    } else {
                                      return TRoundedImage(
                                          isNetworkImage: true,
                                          applyImageRadius: true,
                                          borderRadius: 200,
                                          imageUrl: userController
                                              .user.value.profilePicture,
                                          width: 60,
                                          height: 60);
                                    }
                                  })),
                              const SizedBox(
                                width: TSizes.md,
                              ),

                              // -----Profile name
                              Obx(() {
                                if (userController.profileLoading.value) {
                                  return const TShimmerEffect(
                                      width: 80, height: 15);
                                } else {
                                  return ProfileName(
                                    color: TColors.primaryBackground,
                                    heading: userController.user.value.email,
                                    name: userController.user.value.fullName,
                                  );
                                }
                              })
                            ],
                          ),
                          IconButton(
                              onPressed: () {
                                Get.to(const ProfileScreen());
                              },
                              icon: const Icon(
                                Iconsax.edit,
                                color: TColors.white,
                              ))
                        ],
                      )),
                  const SizedBox(height: TSizes.spaceBtwSections),
                ],
              ),
            ),

            /// -- Profile Body
            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace - 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TSettingsMenuTile(
                  //     icon: Iconsax.notification,
                  //     title: 'Notifications',
                  //     subTitle: 'Set any kind of notification message',
                  //     onTap: () {}),
                  // const TSettingsMenuTile(
                  //     icon: Iconsax.security_card,
                  //     title: 'Account Privacy',
                  //     subTitle: 'Manage data usage and connected accounts'),

                  /// -- App Settings

                  const TSectionHeading(
                      title: 'App Settings', showActionButton: false),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  Obx(
                    () => TSettingsMenuTile(
                      icon: settingController.isLight.value
                          ? Iconsax.sun_1
                          : Iconsax.moon,
                      title: 'Dark Mode',
                      subTitle: 'Set the light mode you prefer',
                      trailing: Switch(
                          activeColor: TColors.complementary,
                          value: settingController.isLight.value,
                          onChanged: (value) {
                            {
                              settingController.toggleLight();
                            }
                          }),
                    ),
                  ),

                  /// -- Logout Button
                  const SizedBox(height: TSizes.spaceBtwSections),


                  SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                          onPressed: () => Get.offAll(
                              AuthenticationRepository.instance.logOut()),
                          child: const Text('Logout'))),
                  const SizedBox(height: TSizes.spaceBtwSections * 2.5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TUserProfileTile {}
