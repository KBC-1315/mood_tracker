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
    apiKey: 'AIzaSyBrF2IBh0wSVaRDRw0UT39nXL7CVVs93HM',
    appId: '1:637497346681:web:d83adef55db9b06ca1e2a8',
    messagingSenderId: '637497346681',
    projectId: 'mood-tracker-tobe13155131',
    authDomain: 'mood-tracker-tobe13155131.firebaseapp.com',
    storageBucket: 'mood-tracker-tobe13155131.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyClo6T9cl2VHJ_ogb04SIM0As6LZHCA3PI',
    appId: '1:637497346681:android:6ee5ecc6036ba1d8a1e2a8',
    messagingSenderId: '637497346681',
    projectId: 'mood-tracker-tobe13155131',
    storageBucket: 'mood-tracker-tobe13155131.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA1fLwjTPqkAe1I8hW2Kk5rh-MdLPGKrjo',
    appId: '1:637497346681:ios:0ca0009fca44b622a1e2a8',
    messagingSenderId: '637497346681',
    projectId: 'mood-tracker-tobe13155131',
    storageBucket: 'mood-tracker-tobe13155131.appspot.com',
    iosBundleId: 'com.example.moodTracker',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA1fLwjTPqkAe1I8hW2Kk5rh-MdLPGKrjo',
    appId: '1:637497346681:ios:0ca0009fca44b622a1e2a8',
    messagingSenderId: '637497346681',
    projectId: 'mood-tracker-tobe13155131',
    storageBucket: 'mood-tracker-tobe13155131.appspot.com',
    iosBundleId: 'com.example.moodTracker',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBrF2IBh0wSVaRDRw0UT39nXL7CVVs93HM',
    appId: '1:637497346681:web:177083da5f859097a1e2a8',
    messagingSenderId: '637497346681',
    projectId: 'mood-tracker-tobe13155131',
    authDomain: 'mood-tracker-tobe13155131.firebaseapp.com',
    storageBucket: 'mood-tracker-tobe13155131.appspot.com',
  );
}
