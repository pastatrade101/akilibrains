import 'package:flutter/material.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../../utils/constants/colors.dart';




class OnBoardingPage extends StatelessWidget {
  /// Widget for displaying content on an onboarding page.
  const OnBoardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.subTitle,
  });

  final String image, title, subTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        children: [
          // Display the onboarding image
          Image(
            width: THelperFunctions.screenWidth() * 0.8,
            height: THelperFunctions.screenHeight() * 0.6,
            image: AssetImage(image),
          ),
          // Display the onboarding title
          Text(title, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
          const SizedBox(height: TSizes.spaceBtwItems-6),
          // Display the onboarding subtitle
          Text(subTitle, style:  TextStyle(fontSize: 18,color:THelperFunctions.isDarkMode(context)?TColors.white: TColors.black.withOpacity(0.5)), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
