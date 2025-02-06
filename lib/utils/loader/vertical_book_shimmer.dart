import 'package:trade101/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import '../../../utils/constants/sizes.dart';
import '../../common/widgets/layouts/grid_layout.dart';
import '../../common/widgets/shimmer/shimmer_effect.dart';


class TVerticalProductShimmer extends StatelessWidget {
  const TVerticalProductShimmer({
    super.key,
    this.itemCount = 4,
  });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final axisCount = TDeviceUtils.getScreenWidth(context);
    return TGridLayout(
      itemCount: itemCount,
      itemBuilder: (_, __) => const SizedBox(
        width: 180,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Image
            TShimmerEffect(width: 180, height: 180),
            SizedBox(height: TSizes.spaceBtwItems),

            /// Text
            TShimmerEffect(width: 160, height: 15),
            SizedBox(height: TSizes.spaceBtwItems / 2),
            TShimmerEffect(width: 110, height: 15),
          ],
        ),
      ), crossAxisCount: (axisCount >420)?4:2,
    );
  }
}
