import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAoA7I02WSgMq8F7j9RjAnVoZNVleznMjE',
    appId: '1:436150981342:web:65bf46f755a794b155684f',
    messagingSenderId: '436150981342',
    projectId: 'solar-scrap-169f2',
    authDomain: 'solar-scrap-169f2.firebaseapp.com',
    storageBucket: 'solar-scrap-169f2.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB1sJ3Ap_DnkUbsGeeHur-5pRF6v5LNaJg',
    appId: '1:436150981342:android:9d9f738ad3a1f5af55684f',
    messagingSenderId: '436150981342',
    projectId: 'solar-scrap-169f2',
    storageBucket: 'solar-scrap-169f2.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAoA7I02WSgMq8F7j9RjAnVoZNVleznMjE',
    appId: '1:436150981342:ios:27d5cc56a6b86e5855684f',
    messagingSenderId: '436150981342',
    projectId: 'solar-scrap-169f2',
    storageBucket: 'solar-scrap-169f2.firebasestorage.app',
    iosClientId: '436150981342-u70s82v7uq5alnljm47a2dvb4622edkh.apps.googleusercontent.com',
    iosBundleId: 'com.example.solarScrap',
  );
}
