import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FiveStarRating extends StatelessWidget {
  final double initialRating;
  final double itemSize;
  final double glowRadius;
  final bool allowHalfRating;
  final Function(double)? onRatingUpdate;

  const FiveStarRating({
    Key? key,
    this.initialRating = 3,
    this.itemSize = 16,
    this.glowRadius = 7,
    this.allowHalfRating = true,
    this.onRatingUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      itemSize: itemSize,
      glowRadius: glowRadius,
      initialRating: initialRating,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: allowHalfRating,
      itemCount: 5,
      itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ), onRatingUpdate: (double value) {  },

    );
  }
}
