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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    print("[FirebaseOptions] defaultTargetPlatform: $defaultTargetPlatform");
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDo_B1zFP_U-RWcFo2iZ1wl880x_wIZ__k',
    appId: '1:222999477591:android:c4c1b762b7a4739b64d212',
    messagingSenderId: '222999477591',
    projectId: 'laudutest',
    storageBucket: 'laudutest.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDgYKbgeSobu6JbfeOFLLcbNqNEbUjOyvk',
    appId: '1:222999477591:ios:2013fce6f0c9e3c464d212',
    messagingSenderId: '222999477591',
    projectId: 'laudutest',
    storageBucket: 'laudutest.appspot.com',
    androidClientId: '222999477591-62n0vrfphhqo5s0pjsjbjpntpvntfm54.apps.googleusercontent.com',
    iosClientId: '222999477591-ablefd57n55lf712hu9lhuvpqh9dndbe.apps.googleusercontent.com',
    iosBundleId: 'com.example.dashclicker',
  );
}
