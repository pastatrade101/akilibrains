import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:upgrader/upgrader.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'app.dart';
import 'data/repositories/authentication/authentication_repository.dart';
import 'firebase_options.dart'; // Assuming your app widget is named MyApp

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Your background message handling code
  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  // Ensure Flutter framework is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((FirebaseApp value) => Get.put(AuthenticationRepository()));

  // Preserve native splash screen
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Request notification permission
  await requestNotificationPermission();
  await Upgrader.clearSavedSettings();

  // Configure Firebase Messaging background handler
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Configure Firebase Messaging message handler
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');
    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
      showLocalNotification(message);
    }
  });

  // // Get FCM token
  // final fcmToken = await FirebaseMessaging.instance.getToken();
  // print('FCM Token: $fcmToken');

  // Initialize local storage
  await GetStorage.init();

  // Run the app
  runApp(
    UpgradeAlert(
      upgrader: Upgrader(),
      barrierDismissible: false,
      showReleaseNotes: true,
      showIgnore: false,
      child: const App(), // Assuming your app widget is named MyApp
    ),
  );
}

Future<void> requestNotificationPermission() async {
  // Request notification permission
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  print('Notification PermissionGranted: ${settings.authorizationStatus}');
}

void showLocalNotification(RemoteMessage message) async {
  // Initialize the FlutterLocalNotificationsPlugin.
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // Android-specific initialization settings for local notifications.
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  // General initialization settings for local notifications.
  final InitializationSettings initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Create a notification details object.
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
    'your_channel_id', // Change this to a unique channel ID.
    'Channel name', // Change this to a unique channel name.

    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
  );
  const NotificationDetails platformChannelSpecifics =
  NotificationDetails(android: androidPlatformChannelSpecifics);

  // Show the notification.
  await flutterLocalNotificationsPlugin.show(
    0,
    message.notification!.title, // Use the FCM notification title.
    message.notification!.body, // Use the FCM notification body.
    platformChannelSpecifics,
    payload: 'notification_payload',
  );
}
