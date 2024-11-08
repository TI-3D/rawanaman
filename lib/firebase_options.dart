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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBzEphl5QtFLxcEpbstwUtrkwUi7LwqlWQ',
    appId: '1:434112925248:web:0f9d3545d91919e46519a5',
    messagingSenderId: '434112925248',
    projectId: 'rawanaman-8c43f',
    authDomain: 'rawanaman-8c43f.firebaseapp.com',
    storageBucket: 'rawanaman-8c43f.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAgrTVE3SUSDBigkWQQR8ixTnytWtGOL0k',
    appId: '1:434112925248:android:de4822526d23e64f6519a5',
    messagingSenderId: '434112925248',
    projectId: 'rawanaman-8c43f',
    storageBucket: 'rawanaman-8c43f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBBLF657u-fkRgiqhtbnCR6tsw0mCn9eeE',
    appId: '1:434112925248:ios:0aa24dacd08fb7836519a5',
    messagingSenderId: '434112925248',
    projectId: 'rawanaman-8c43f',
    storageBucket: 'rawanaman-8c43f.appspot.com',
    iosBundleId: 'com.example.rawanaman',
  );

}