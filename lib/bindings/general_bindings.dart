import 'package:get/get.dart';

import '../utils/network/network_connectivity_check.dart';


class GeneralBindings extends Bindings{
  @override
  void dependencies() {
    Get.put(NetworkManager());

    // TODO: implement dependencies
  }


}