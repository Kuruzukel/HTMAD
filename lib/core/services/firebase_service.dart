import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../app_config.dart';

class FirebaseService {
  static FirebaseApp? _app;
  static FirebaseAuth? _auth;
  static FirebaseFirestore? _firestore;

  static FirebaseApp get app => _app!;
  static FirebaseAuth get auth => _auth!;
  static FirebaseFirestore get firestore => _firestore!;

  static Future<void> initialize() async {
    try {
      // Initialize Firebase with emulator configuration
      _app = await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'demo-api-key',
          appId: 'demo-app-id',
          messagingSenderId: 'demo-sender-id',
          projectId: AppConfig.firebaseProjectId,
        ),
      );

      // Initialize Firebase Auth with emulator
      _auth = FirebaseAuth.instanceFor(app: _app!);
      await _auth!.useAuthEmulator(
        AppConfig.authEmulatorHost,
        AppConfig.authEmulatorPort,
      );

      // Initialize Firestore with emulator
      _firestore = FirebaseFirestore.instanceFor(app: _app!);
      _firestore!.useFirestoreEmulator(
        AppConfig.firestoreEmulatorHost,
        AppConfig.firestoreEmulatorPort,
      );

      if (kDebugMode) {
        debugPrint('Firebase initialized successfully with emulators');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error initializing Firebase: $e');
      }
      // For development, we'll continue without Firebase if emulators aren't running
      // In production, you might want to handle this differently
    }
  }

  static bool get isInitialized => _app != null;

  static Future<void> signOut() async {
    if (_auth != null) {
      await _auth!.signOut();
    }
  }
}
