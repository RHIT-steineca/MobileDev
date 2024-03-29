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
    apiKey: 'AIzaSyDDqVVp-FMl5PZQ30fPt5sf4tbQIpe53ZQ',
    appId: '1:691772901538:web:f92d6df200051795f22ffb',
    messagingSenderId: '691772901538',
    projectId: 'flutterm',
    authDomain: 'flutterm.firebaseapp.com',
    storageBucket: 'flutterm.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAMLh1V1DlGgqdzI_GeaS7QiWNGqvQFTkg',
    appId: '1:691772901538:android:7eb18873c6ac0f8ff22ffb',
    messagingSenderId: '691772901538',
    projectId: 'flutterm',
    storageBucket: 'flutterm.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCFcBw6357XaLfRVOMGNS_A8HEMUfxMBTc',
    appId: '1:691772901538:ios:d21878dde075c177f22ffb',
    messagingSenderId: '691772901538',
    projectId: 'flutterm',
    storageBucket: 'flutterm.appspot.com',
    iosClientId: '691772901538-vednm98t4cfu66bcc2bk9seb2ke6pekl.apps.googleusercontent.com',
    iosBundleId: 'com.example.movieQuotes',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCFcBw6357XaLfRVOMGNS_A8HEMUfxMBTc',
    appId: '1:691772901538:ios:d21878dde075c177f22ffb',
    messagingSenderId: '691772901538',
    projectId: 'flutterm',
    storageBucket: 'flutterm.appspot.com',
    iosClientId: '691772901538-vednm98t4cfu66bcc2bk9seb2ke6pekl.apps.googleusercontent.com',
    iosBundleId: 'com.example.movieQuotes',
  );
}
