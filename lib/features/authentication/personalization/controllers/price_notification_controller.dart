// import 'dart:async';
// import 'dart:convert';
// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
//
// import '../../../cryptocurrency_data/controller/pivots_controller.dart';
//
// class CurrentPriceController extends GetxController {
//   static CurrentPriceController get instance => Get.find();
//   PivotController pivotController = Get.put(PivotController());
//
//   final currentPrice = 0.0.obs;
//
//   // Initialize currentPrice variable
//
//   @override
//   void onInit() {
//     super.onInit();
//
//     Timer.periodic(const Duration(seconds: 5), (timer) {
//       fetchData(); // Call the method to fetch data periodically
//     });
//   }
//
//   Future<void> fetchData() async {
//     try {
//       final response = await http.get(Uri.parse(
//           'https://api.taapi.io/price?secret=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjbHVlIjoiNjYyYTA0ZDBmNWFmOTRlZWNlNDRjNDI1IiwiaWF0IjoxNzE0MDMwMDY5LCJleHAiOjMzMjE4NDk0MDY5fQ.DEC8WbJiwjjgBwE6uip_0c8aj2Q2QPXsgt6vFMhSyI4&exchange=binance&symbol=BTC/USDT&interval=1h'));
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//
//         currentPrice.value = data['value'];
//
//         // Compare fetched price with the provided data
//         double resistance1 = pivotController.pivotPoints.value.resistance1;
//         double resistance2 = pivotController.pivotPoints.value.resistance2;
//         double resistance3 = pivotController.pivotPoints.value.resistance3;
//
//         // Define a threshold for the price difference
//         double threshold = 100.0; // Adjust this threshold as needed
//
//         // Check if the price is within the threshold range
//         if ((currentPrice.value - resistance1).abs() <= threshold) {
//           // If the price is near the pivot price, send a notification
//           sendNotification(currentPrice.value);
//         } else if ((currentPrice.value - resistance2).abs() <= threshold) {
//           sendNotification(currentPrice.value);
//         }else if ((currentPrice.value - resistance3).abs() <= threshold) {
//           sendNotification(currentPrice.value);
//         }
//       } else {
//         print('Failed to fetch data: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Exception occurred: $e');
//     }
//   }
//
//   void sendNotification(double currentPrice) {
//     // Build notification content
//     String title = 'Price Alert';
//     String body =
//         'Current price is near the pivot point: \$${currentPrice.toStringAsFixed(2)}';
//
//     // Create notification
//     AwesomeNotifications().createNotification(
//       content: NotificationContent(
//         id: 0,
//         channelKey: 'Basic Channel',
//         title: title,
//         body: body,
//       ),
//     );
//   }
// }
