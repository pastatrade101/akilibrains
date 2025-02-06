
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:trade101/features/authentication/personalization/screens/profile/widgets/profile_menu.dart';


import '../../../../../common/widgets/appbar/appbar.dart';

import '../../../../../common/widgets/custom_shapes/containers/circular_container.dart';

import '../../../../../common/widgets/shimmer/shimmer_effect.dart';
import '../../../../../common/widgets/texts/section_heading.dart';
import '../../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';

import '../../controllers/user_controller.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userController = UserController.instance;
    return Scaffold(
      appBar: TAppBar(
        centerTitle: true,
        showBackArrow: true,
        title: Text('User Profile',
            style: Theme.of(context).textTheme.headlineSmall),
        padding: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [


                    TCircularContainer(
                        width: 100,
                        height: 100,
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 4),
                        borderColor: TColors.primary,
                        showBorder: true,
                        child: Obx(() {
                          if (userController.profileLoading.value) {
                            return const TShimmerEffect(width: 40, height: 15);
                          } else {
                            final networkImage =
                                userController.user.value.profilePicture;
                            final image = networkImage.isNotEmpty
                                ? networkImage
                                : TImages.user1;
                            if(userController.imageUploading.value){return const TShimmerEffect(width: 55, height: 55,radius: 55,);}else {
                              return networkImage.isNotEmpty
                                ? ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: CachedNetworkImage(
                                  fit: BoxFit.cover,progressIndicatorBuilder: (context,url,downloadProgress)=>const TShimmerEffect(width:55, height: 55,radius: 55,),
                                  imageUrl: networkImage),)
                                : ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image(
                                  fit: BoxFit.cover,
                                  image: AssetImage(

                                  image)),
                                );
                            }
                          }
                        })),
                    const SizedBox(
                      height: TSizes.spaceBtwItems,
                    ),
                    Obx(() {
                      if (userController.profileLoading.value) {
                        return const TShimmerEffect(width: 80, height: 15);
                      } else {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [const Icon(Iconsax.edit,color: TColors.complementary,),const SizedBox(width: TSizes.sm,) ,TextButton(
                          onPressed:  () => userController.uploadProfilePicture(),
                          child:  Text('Change profile picture',style: Theme.of(context).textTheme.titleMedium!.copyWith(color: TColors.complementary),),
                        )],);
                      }
                    }),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems / 2),
              const Divider(),
              const SizedBox(height: TSizes.spaceBtwItems),
              const TSectionHeading(
                  title: 'Profile Information', showActionButton: false),
              const SizedBox(height: TSizes.spaceBtwItems),
              Obx(() {
                if (userController.profileLoading.value) {
                  return const TShimmerEffect(width: 80, height: 15);
                } else {
                  return TProfileMenu(
                      onPressed: () => {},
                      title: 'Name',
                      value: userController.user.value.firstName +
                          userController.user.value.lastName);
                }
              }),
              Obx(() {
                if (userController.profileLoading.value) {
                  return const TShimmerEffect(width: 80, height: 15);
                } else {
                  return TProfileMenu(
                      onPressed: () => {},
                      title: 'User Name',
                      value: userController.user.value.userName);
                }
              }),
              const SizedBox(height: TSizes.spaceBtwItems),
              const Divider(),
              const SizedBox(height: TSizes.spaceBtwItems),
              const TSectionHeading(
                  title: 'Personal Information', showActionButton: false),
              const SizedBox(height: TSizes.spaceBtwItems),
              Obx(() {
                if (userController.profileLoading.value) {
                  return const TShimmerEffect(width: 80, height: 15);
                } else {
                  return TProfileMenu(
                      onPressed: () => {},
                      title: 'User ID',
                      value: userController.user.value.id);
                }
              }),
              Obx(() {
                if (userController.profileLoading.value) {
                  return const TShimmerEffect(width: 80, height: 15);
                } else {
                  return TProfileMenu(
                      onPressed: () => {},
                      title: 'Email',
                      value: userController.user.value.email);
                }
              }),
              Obx(() {
                if (userController.profileLoading.value) {
                  return const TShimmerEffect(width: 80, height: 15);
                } else {
                  return TProfileMenu(
                      onPressed: () => {},
                      title: 'Phone Number',
                      value: userController.user.value.phoneNumber);
                }
              }),

              const Divider(),
              const SizedBox(height: TSizes.spaceBtwItems),

              const SizedBox(height: TSizes.spaceBtwItems),

              /// -- Logout Button
              const SizedBox(height: TSizes.spaceBtwSections),
              SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                      onPressed: () => Get.offAll(
                          AuthenticationRepository.instance.logOut()),
                      child: const Text('Logout'))),
              const SizedBox(height: TSizes.spaceBtwSections),
              const SizedBox(
                height: 60,
              )
            ],
          ),
        ),
      ),
    );
  }
}
