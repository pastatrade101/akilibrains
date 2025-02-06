import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';


import '../../../../../common/images/t_rounded_image.dart';
import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../utils/constants/colors.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class BoughtBooks extends StatelessWidget {
  const BoughtBooks({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: THelperFunctions.isDarkMode(context)
          ? TColors.black
          : TColors.primaryBackground,
      appBar: const TAppBar(
          padding: 0,
          showBackArrow: true,
          title: Text('My Books'),
          centerTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace - 8),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: TColors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: TColors.grey, // Border color
                    width: 1.0, // Border width
                  ),
                ),
                child: ListTile(
                  onTap: () {},
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 12.0),
                  leading: const TRoundedImage(
                      borderRadius: 2,
                      width: 40,
                      height: 80,
                      isNetworkImage: true,
                      fit: BoxFit.cover,
                      imageUrl:
                          'https://firebasestorage.googleapis.com/v0/b/rabit-store.appspot.com/o/books%2Finvesting.jpg?alt=media&token=f15d11da-b95a-4411-9e67-4917b12c0e1e'),
                  title: Text(
                    'How to become a monopoly ',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    'Nickyrabit',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  trailing: const Icon(Iconsax.arrow_circle_right),
                ),
              ),
              const SizedBox(
                height: TSizes.sm,
              ),
              Container(
                decoration: BoxDecoration(
                  color: TColors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: TColors.grey, // Border color
                    width: 1.0, // Border width
                  ),
                ),
                child: ListTile(
                  onTap: () {},
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 12.0),
                  leading: const TRoundedImage(
                      borderRadius: 2,
                      width: 40,
                      height: 80,
                      isNetworkImage: true,
                      fit: BoxFit.cover,
                      imageUrl:
                          'https://firebasestorage.googleapis.com/v0/b/rabit-store.appspot.com/o/books%2Finvesting.jpg?alt=media&token=f15d11da-b95a-4411-9e67-4917b12c0e1e'),
                  title: Text(
                    'How to become a monopoly ',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    'Nickyrabit',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  trailing: const Icon(Iconsax.arrow_circle_right),
                ),
              ),






            ],
          ),
        ),
      ),
    );
  }
}
