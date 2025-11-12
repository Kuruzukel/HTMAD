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
      // Check if Firebase is already initialized
      if (Firebase.apps.isNotEmpty) {
        _app = Firebase.app();
        _auth = FirebaseAuth.instance;
        _firestore = FirebaseFirestore.instance;

        if (kDebugMode) {
          debugPrint('Firebase already initialized, reusing existing instance');
        }
        return;
      }

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

      try {
        await _auth!.useAuthEmulator(
          AppConfig.authEmulatorHost,
          AppConfig.authEmulatorPort,
        );
        if (kDebugMode) {
          debugPrint('Connected to Firebase Auth Emulator');
        }
      } catch (e) {
        if (kDebugMode) {
          debugPrint('Could not connect to Auth Emulator: $e');
        }
      }

      // Initialize Firestore with emulator
      _firestore = FirebaseFirestore.instanceFor(app: _app!);

      try {
        _firestore!.useFirestoreEmulator(
          AppConfig.firestoreEmulatorHost,
          AppConfig.firestoreEmulatorPort,
        );
        if (kDebugMode) {
          debugPrint('Connected to Firestore Emulator');
        }
      } catch (e) {
        if (kDebugMode) {
          debugPrint('Could not connect to Firestore Emulator: $e');
        }
      }

      if (kDebugMode) {
        debugPrint('Firebase initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error initializing Firebase: $e');
      }
      rethrow; // Re-throw to handle at app level
    }
  }

  static bool get isInitialized => _app != null;

  static Future<void> signOut() async {
    if (_auth != null) {
      await _auth!.signOut();
    }
  }
}
