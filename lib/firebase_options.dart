// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDURDOpg3jIWh2y68fmSB1XxjxsDTvL5vw',
    appId: '1:566559401387:web:5ab9550b2b0afd015a9eee',
    messagingSenderId: '566559401387',
    projectId: 'rabit-store',
    authDomain: 'rabit-store.firebaseapp.com',
    storageBucket: 'rabit-store.appspot.com',
    measurementId: 'G-6BSWHXJD9M',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDIY6xnvbEqoCT1TwhOLi3V_yKMzQ6c7Xc',
    appId: '1:566559401387:android:281445b84b659d9d5a9eee',
    messagingSenderId: '566559401387',
    projectId: 'rabit-store',
    databaseURL: 'https://rabit-store-default-rtdb.firebaseio.com',
    storageBucket: 'rabit-store.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD0UV64NaGh_aPz7YOW3DlDcvCumeBkhxg',
    appId: '1:566559401387:ios:a9d2c3be06faaa755a9eee',
    messagingSenderId: '566559401387',
    projectId: 'rabit-store',
    storageBucket: 'rabit-store.appspot.com',
    androidClientId: '566559401387-m5k0p9irjeat3ltbneiiobh7ofpa5a1i.apps.googleusercontent.com',
    iosClientId: '566559401387-mufgfkh3mgvtj7ue99mbqlh1roi1n0cu.apps.googleusercontent.com',
    iosBundleId: 'com.example.rabitStore',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD0UV64NaGh_aPz7YOW3DlDcvCumeBkhxg',
    appId: '1:566559401387:ios:5afe4003bd4615685a9eee',
    messagingSenderId: '566559401387',
    projectId: 'rabit-store',
    storageBucket: 'rabit-store.appspot.com',
    androidClientId: '566559401387-m5k0p9irjeat3ltbneiiobh7ofpa5a1i.apps.googleusercontent.com',
    iosClientId: '566559401387-i3rh1qr5q9mmeqtrftvibqo20r0ogrf8.apps.googleusercontent.com',
    iosBundleId: 'com.example.rabitStore.RunnerTests',
  );
}