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
    apiKey: 'AIzaSyCBm4RjTA8tEglBcYrF6g2DC0RbBxkQdws',
    appId: '1:805913972339:web:c85866093cbc5dcff9a406',
    messagingSenderId: '805913972339',
    projectId: 'traveler-57e1b',
    authDomain: 'traveler-57e1b.firebaseapp.com',
    storageBucket: 'traveler-57e1b.appspot.com',
    measurementId: 'G-89L03T6V2L',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA_gFxt3m8bSwLxKa3jkIM3WeOeLs8Ltpc',
    appId: '1:805913972339:android:3fc167c6833b6930f9a406',
    messagingSenderId: '805913972339',
    projectId: '',
    storageBucket: 'traveler-57e1b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCOdQ8ew6sjQblfTQWtHwZEQlr5wyYeiD8',
    appId: '1:805913972339:ios:439face4d321f088f9a406',
    messagingSenderId: '805913972339',
    projectId: 'traveler-57e1b',
    storageBucket: 'traveler-57e1b.appspot.com',
    iosBundleId: '',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCOdQ8ew6sjQblfTQWtHwZEQlr5wyYeiD8',
    appId: '1:805913972339:ios:439face4d321f088f9a406',
    messagingSenderId: '805913972339',
    projectId: 'traveler-57e1b',
    storageBucket: '',
    iosBundleId: 'com.travel.traveler',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCBm4RjTA8tEglBcYrF6g2DC0RbBxkQdws',
    appId: '1:805913972339:web:62000a21da85e2e6f9a406',
    messagingSenderId: '805913972339',
    projectId: 'traveler-57e1b',
    authDomain: 'traveler-57e1b.firebaseapp.com',
    storageBucket: 'traveler-57e1b.appspot.com',
    measurementId: 'G-3GKZYM5GKM',
  );

}
