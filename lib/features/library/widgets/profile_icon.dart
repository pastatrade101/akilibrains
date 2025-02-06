import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';
class ProfileIcon extends StatelessWidget {
  const ProfileIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return  TRoundedContainer(
      padding: EdgeInsets.all(TSizes.sm),
      backgroundColor:  THelperFunctions.isDarkMode(context)?TColors.darkerGrey:TColors.white,
      radius: 100,
      child: Icon(
        Iconsax.profile_circle,
        size: 24,
        color:THelperFunctions.isDarkMode(context)? TColors.accent:TColors.darkerGrey,
      ),
    );
  }
}