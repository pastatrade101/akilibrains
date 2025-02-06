import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';

class PolicyText extends StatelessWidget {
  const PolicyText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(TextSpan(children: [
      TextSpan(
          text:
          'By clicking "Sign in" above, you agree to Rabit-Store ',style:Theme.of(context).textTheme.labelMedium),
      TextSpan(text: 'Terms & Conditions',style:Theme.of(context).textTheme.bodyLarge!.copyWith(color: TColors.accent)),
      TextSpan(text: ' and ',style:Theme.of(context).textTheme.labelMedium),
      TextSpan(text: 'Privacy Policy',style:Theme.of(context).textTheme.bodyLarge!.copyWith(color: TColors.accent))
    ]));
  }
}