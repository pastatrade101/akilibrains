// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class NotificationSettingController extends GetxController {
  static NotificationSettingController get instance => Get.find();
  //
  // // Use this notification method when new notification created or scheduled
  // @pragma("vm:entry-point")
  // static Future<void> onNotificationCreatedMethod(
  //     ReceivedNotification receivedNotification) async {}
  //
  // // Use this notification method every time notification has been displayed
  // @pragma("vm:entry-point")
  // static Future<void> onNotificationDisplayMethod(
  //     ReceivedNotification
  //         receivedNotification) async {} // Use this notification method every time notification has been displayed
  // @pragma("vm:entry-point")
  // static Future<void> onDismissActionReceivedMethod(
  //     ReceivedNotification receivedNotification) async {}
  //
  // @pragma("vm:entry-point")
  // static Future<void> onActionReceivedMethod(
  //     ReceivedNotification receivedNotification) async {}
  //
  // @override
  // void onInit() {
  //   super.onInit();
  //   AwesomeNotifications().setListeners(
  //       onActionReceivedMethod: onActionReceivedMethod,
  //       onDismissActionReceivedMethod: onDismissActionReceivedMethod,
  //       onNotificationCreatedMethod: onNotificationCreatedMethod,
  //       onNotificationDisplayedMethod: onNotificationDisplayMethod);
  // }

  /// Variables
  final RxBool isLight = true.obs;

  void toggleLight() {
    // Toggle the value of isLight
    isLight.value = !isLight.value;
  }
}
