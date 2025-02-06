
import 'package:flutter/material.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../common/widgets/login_signup/form_divider.dart';
import '../../../../common/widgets/login_signup/social_buttons.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: THelperFunctions.isDarkMode(context)?TColors.black:TColors.primaryBackground,appBar: TAppBar(padding: 0,color: THelperFunctions.isDarkMode(context)?TColors.black:TColors.primaryBackground),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: TSizes.defaultSpace, vertical: 64),
          child: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const TRoundedContainer(
                  width: 100,
                  radius: 300,
                  backgroundColor: TColors.primary,
                  child: Image(image: AssetImage(TImages.loginLogo)),
                ),
                const SizedBox(
                  height: TSizes.spaceBtwItems,
                ),
                Text(
                  'Sign in to your account',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const TLoginForm(),
                const TFormDivider(dividerText: 'Login with Google'),
                const SizedBox(
                  height: TSizes.spaceBtwItems,
                ),
                const TSocialButtons()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
