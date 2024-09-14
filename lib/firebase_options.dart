// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyAI--CR8gmPN5zDFhWlpaUFD1gopphXOBw',
    appId: '1:652009158621:web:249f1aeafce04260e86834',
    messagingSenderId: '652009158621',
    projectId: 'csmsoft-dd530',
    authDomain: 'csmsoft-dd530.firebaseapp.com',
    storageBucket: 'csmsoft-dd530.appspot.com',
    measurementId: 'G-0NXK7QGDFN',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCimfIrFeycbfUZ_SBsgygThRZ7cI8oCQ4',
    appId: '1:652009158621:android:c8b7e423422ca825e86834',
    messagingSenderId: '652009158621',
    projectId: 'csmsoft-dd530',
    storageBucket: 'csmsoft-dd530.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDGxuqDm8qx0OWAjzQ79vOeEwtL5zVLnRA',
    appId: '1:652009158621:ios:c26c368a25ff907fe86834',
    messagingSenderId: '652009158621',
    projectId: 'csmsoft-dd530',
    storageBucket: 'csmsoft-dd530.appspot.com',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDGxuqDm8qx0OWAjzQ79vOeEwtL5zVLnRA',
    appId: '1:652009158621:ios:c26c368a25ff907fe86834',
    messagingSenderId: '652009158621',
    projectId: 'csmsoft-dd530',
    storageBucket: 'csmsoft-dd530.appspot.com',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAI--CR8gmPN5zDFhWlpaUFD1gopphXOBw',
    appId: '1:652009158621:web:751958df21c06b5ee86834',
    messagingSenderId: '652009158621',
    projectId: 'csmsoft-dd530',
    authDomain: 'csmsoft-dd530.firebaseapp.com',
    storageBucket: 'csmsoft-dd530.appspot.com',
    measurementId: 'G-2VJ9E301YH',
  );
}
