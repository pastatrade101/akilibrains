import 'package:flutter/material.dart';


import '../../../utils/constants/colors.dart';
import '../../../utils/helpers/helper_functions.dart';

class AuthorWidget extends StatelessWidget {
  const AuthorWidget({
    super.key, required this.author, this.size,
  });

  final String author;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 68,
      child: Text(
        author,
        style:
        Theme
            .of(context)
            .textTheme
            .labelLarge!.copyWith(color: THelperFunctions.isDarkMode(context)?TColors.primaryBackground.withOpacity(0.6):TColors.darkerGrey.withOpacity(0.8)),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
