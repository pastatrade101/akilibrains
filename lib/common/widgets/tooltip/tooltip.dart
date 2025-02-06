import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../custom_shapes/containers/rounded_container.dart';

class TooltipCrypto extends StatelessWidget {
  const TooltipCrypto({
    super.key, required this.info,
  });
final String info;
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.all(TSizes.md),
      triggerMode: TooltipTriggerMode.tap,
      showDuration: const Duration(seconds: 15),
      message:
      info,
      child: TRoundedContainer(showBorder: true, borderColor: TColors.lightGrey,backgroundColor: Colors.white.withOpacity(0.5), child: const Icon(CupertinoIcons.question,size: 16,)),
    );
  }
}