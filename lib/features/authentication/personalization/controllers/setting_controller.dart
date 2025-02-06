import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class SettingController extends GetxController {
  static SettingController get instance => Get.find();

  /// Variables
  /// Variables
  final RxBool isLight = true.obs;

  void toggleLight() {
    // Toggle the value of isLight
    isLight.value = !isLight.value;
  }
}
