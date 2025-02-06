import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';import 'package:http/http.dart' as http;

class FCMController extends GetxController {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void onInit() {
    super.onInit();
    initializeLocalNotifications();
    _firebaseMessaging.subscribeToTopic('tradeSignal');
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        showLocalNotification(message.notification!);
      }
    });
  }

  void initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showLocalNotification(RemoteNotification notification) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your_channel_id',
      'Channel name',

      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.show(
      0,
      notification.title!,
      notification.body!,
      platformChannelSpecifics,
      payload: 'notification_payload',
    );
  }

  Future<void> sendNotification() async {
    // Your FCM server key
    String serverKey = 'AAAAg-mSZas:APA91bE_--ReIjyhN0mI1mNI4IoQbsLYGyJkoUecdMa6uJV16GOpGJaz1n-RrDLmguWGdQo1SOHi88F4ZM__xzAmLprYNhIr1-yTi-6lcJPuz3-OCx9mxPkNfmGkCfF5Q-ByPEHANrcf';
    // FCM endpoint
    Uri url = Uri.parse('https://fcm.googleapis.com/v1/projects/rabit-store/messages:send');

    // Your notification payload
    Map<String, dynamic> notification = {
      'title': 'Notification Title',
      'body': 'Notification Body',
    };

    // Message data
    Map<String, dynamic> data = {
      'key1': 'value1',
      'key2': 'value2',
    };

    // FCM request body
    Map<String, dynamic> requestBody = {
      'message': {
        'notification': notification,
        'data': data,
        'topic': 'tradeSignal', // Topic to which the notification will be sent
      }
    };

    // Send FCM request
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serverKey',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Failed to send notification. Error: ${response.body}');
    }
  }
}