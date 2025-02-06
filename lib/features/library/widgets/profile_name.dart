import 'package:flutter/material.dart';


class ProfileName extends StatelessWidget {
  const ProfileName({
    super.key,  this.name,  this.heading, this.color,
  });
  final String? name,heading;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name??'',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight:FontWeight.w700,color: color ),
        ),
        Text(
          heading??'',maxLines: 2,overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelMedium!.copyWith(color: color),
        ),

      ],
    );
  }
}