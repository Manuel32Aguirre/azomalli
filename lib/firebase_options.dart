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
    apiKey: 'AIzaSyDMM3XvOIcp2AOEBHnPALdSC23hJJuWEGs',
    appId: '1:447243540021:web:67cc005a9a421d7450837c',
    messagingSenderId: '447243540021',
    projectId: 'azomalli-6b783',
    authDomain: 'azomalli-6b783.firebaseapp.com',
    storageBucket: 'azomalli-6b783.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCekFrAaDCNE7WrcHOcoGFt6o41c7JaIXg',
    appId: '1:447243540021:android:ffa31769153c596250837c',
    messagingSenderId: '447243540021',
    projectId: 'azomalli-6b783',
    storageBucket: 'azomalli-6b783.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB1rYLd4dXhxwznM_sW3doMmBPnDZtbMDg',
    appId: '1:447243540021:ios:351b9dd66c29bded50837c',
    messagingSenderId: '447243540021',
    projectId: 'azomalli-6b783',
    storageBucket: 'azomalli-6b783.firebasestorage.app',
    iosBundleId: 'com.example.azomalli',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB1rYLd4dXhxwznM_sW3doMmBPnDZtbMDg',
    appId: '1:447243540021:ios:351b9dd66c29bded50837c',
    messagingSenderId: '447243540021',
    projectId: 'azomalli-6b783',
    storageBucket: 'azomalli-6b783.firebasestorage.app',
    iosBundleId: 'com.example.azomalli',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDMM3XvOIcp2AOEBHnPALdSC23hJJuWEGs',
    appId: '1:447243540021:web:c776273f1f47b17150837c',
    messagingSenderId: '447243540021',
    projectId: 'azomalli-6b783',
    authDomain: 'azomalli-6b783.firebaseapp.com',
    storageBucket: 'azomalli-6b783.firebasestorage.app',
  );
}