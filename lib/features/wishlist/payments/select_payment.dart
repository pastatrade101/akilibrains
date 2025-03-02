import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../common/widgets/texts/section_heading.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../checkout_controller.dart';


class PaymentOption extends StatelessWidget {
  const PaymentOption({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = CheckoutController.instance;
    return Column(
      children: [
        TSectionHeading(
          title: 'Payment Method',
          buttonTitle: 'Change',
          showActionButton: true,
          onPressed: () {
            controller.selectPaymentMethod(context);
          },
        ),
        const SizedBox(height: TSizes.spaceBtwItems / 2),
        Obx(
              () => Row(
            children: [
              GestureDetector(

                child: TRoundedContainer(
                  width: 60,
                  height: 35,
                  backgroundColor: THelperFunctions.isDarkMode(context) ? TColors.light : TColors.white,
                  padding: const EdgeInsets.all(TSizes.sm),
                  child: Image(image: AssetImage(controller.selectedPaymentMethod.value.image), fit: BoxFit.contain),
                ),onTap: ()=> controller.selectPaymentMethod(context),
              ),
              const SizedBox(width: TSizes.spaceBtwItems / 2),
              Text(controller.selectedPaymentMethod.value.name, style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ),
      ],
    );
  }

}
