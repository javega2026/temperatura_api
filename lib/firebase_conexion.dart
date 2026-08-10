import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

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
          'DefaultFirebaseOptions have not been configured for ios.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBe4qyKMCKTqgXARXlpSNe_035MpMvVESM',
    appId: '1:38246295034:web:d396066fc21d211b7d7043',
    messagingSenderId: '38246295034',
    projectId: 'bdmedusas',
    authDomain: 'bdmedusas.firebaseapp.com',
    storageBucket: 'bdmedusas.firebasestorage.app',
    measurementId: 'G-CSEHFV9WN0',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBe4qyKMCKTqgXARXlpSNe_035MpMvVESM',
    appId: '1:38246295034:web:d396066fc21d211b7d7043',
    messagingSenderId: '38246295034',
    projectId: 'bdmedusas',
    storageBucket: 'bdmedusas.firebasestorage.app',
  );
}