// File generated manually for the project: unitins-projeto
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for iOS.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macOS.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for Windows.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for Linux.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDAgjeVYW4lzmciJKsxusLGX7CrNQALSMM',
    appId: '1:921816636984:web:<INSIRA_SEU_WEB_APP_ID_AQUI>',
    messagingSenderId: '921816636984',
    projectId: 'unitins-projeto',
    databaseURL: 'https://unitins-projeto-default-rtdb.firebaseio.com/',
    authDomain: 'unitins-projeto.firebaseapp.com',
    storageBucket: 'unitins-projeto.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDAgjeVYW4lzmciJKsxusLGX7CrNQALSMM',
    appId: '1:921816636984:android:56ab986e5b57c2a46990cd',
    messagingSenderId: '921816636984',
    projectId: 'unitins-projeto',
    databaseURL: 'https://unitins-projeto-default-rtdb.firebaseio.com/',
    storageBucket: 'unitins-projeto.appspot.com',
  );
}
