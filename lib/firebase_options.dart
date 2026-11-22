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
    apiKey: 'AIzaSyC-N0LG1tNUF-1yDONESDqbzfrc5gzO9lA',
    appId: '1:150146588859:android:cbf6c0f5278d33a8e9c99e',
    messagingSenderId: '150146588859',
    projectId: 'pi-catalogo-peliculas',
    storageBucket: 'pi-catalogo-peliculas.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA5x4X9vIhS-qf6v5BEBDZCBWJLYBGif2g',
    appId: '1:150146588859:ios:edc170538d779b4ce9c99e',
    messagingSenderId: '150146588859',
    projectId: 'pi-catalogo-peliculas',
    storageBucket: 'pi-catalogo-peliculas.firebasestorage.app',
    iosClientId: '150146588859-0rvs9vj5h8dn7qqj5qqj5qqj5qqj5qqj.apps.googleusercontent.com',
    iosBundleId: 'com.example.movieCatalogApp',
  );
}
