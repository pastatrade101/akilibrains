import 'package:flutter/material.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utils/constants/sizes.dart';
import 'orders_list.dart';


class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// -- AppBar
      appBar: TAppBar(title: Text('My Orders', style: Theme.of(context).textTheme.headlineSmall), showBackArrow: true, padding:0,),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: TSizes.defaultSpace-8,vertical: 0),

        /// -- Orders
        child: TOrderListItems(),
      ),
    );
  }
}
