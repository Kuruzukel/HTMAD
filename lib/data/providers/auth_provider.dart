import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/services/firebase_service.dart';
import '../models/user_model.dart';
import '../repositories/user_repository.dart';

enum AuthState {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthProvider extends ChangeNotifier {
  AuthState _state = AuthState.initial;
  User? _firebaseUser;
  UserModel? _user;
  String? _errorMessage;

  final UserRepository _userRepository = UserRepository();

  AuthState get state => _state;
  User? get firebaseUser => _firebaseUser;
  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated =>
      _state == AuthState.authenticated && _user != null;

  AuthProvider() {
    _initializeAuth();
  }

  void _initializeAuth() {
    if (FirebaseService.isInitialized) {
      FirebaseService.auth.authStateChanges().listen(_onAuthStateChanged);
    }
  }

  void _onAuthStateChanged(User? firebaseUser) async {
    _firebaseUser = firebaseUser;

    if (firebaseUser != null) {
      try {
        _setState(AuthState.loading);

        // Try to get user from local database first
        _user = await _userRepository.getUserById(firebaseUser.uid);

        if (_user == null) {
          // Create user profile if doesn't exist
          _user = UserModel(
            id: firebaseUser.uid,
            email: firebaseUser.email ?? '',
            name: firebaseUser.displayName ?? 'User',
            waterGoal: 8,
            exerciseGoal: 30,
            sleepGoal: 8,
            calorieGoal: 2000,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          await _userRepository.createUser(_user!);
        }

        _setState(AuthState.authenticated);
      } catch (e) {
        _setError('Failed to load user profile: $e');
      }
    } else {
      _user = null;
      _setState(AuthState.unauthenticated);
    }
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      _setState(AuthState.loading);

      if (!FirebaseService.isInitialized) {
        throw Exception('Firebase not initialized');
      }

      final credential = await FirebaseService.auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        return true;
      }

      _setError('Sign in failed');
      return false;
    } on FirebaseAuthException catch (e) {
      _setError(_getAuthErrorMessage(e));
      return false;
    } catch (e) {
      _setError('An unexpected error occurred: $e');
      return false;
    }
  }

  Future<bool> createUserWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    try {
      _setState(AuthState.loading);

      if (!FirebaseService.isInitialized) {
        throw Exception('Firebase not initialized');
      }

      final credential =
          await FirebaseService.auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // Update display name
        await credential.user!.updateDisplayName(name);
        return true;
      }

      _setError('Account creation failed');
      return false;
    } on FirebaseAuthException catch (e) {
      _setError(_getAuthErrorMessage(e));
      return false;
    } catch (e) {
      _setError('An unexpected error occurred: $e');
      return false;
    }
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      _setState(AuthState.loading);

      if (!FirebaseService.isInitialized) {
        throw Exception('Firebase not initialized');
      }

      await FirebaseService.auth.sendPasswordResetEmail(email: email);
      _setState(AuthState.unauthenticated);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_getAuthErrorMessage(e));
      return false;
    } catch (e) {
      _setError('An unexpected error occurred: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      _setState(AuthState.loading);

      if (FirebaseService.isInitialized) {
        await FirebaseService.auth.signOut();
      }

      _user = null;
      _firebaseUser = null;
      _setState(AuthState.unauthenticated);
    } catch (e) {
      _setError('Sign out failed: $e');
    }
  }

  Future<bool> updateUserProfile({
    String? name,
    int? age,
    String? gender,
    double? weight,
    double? height,
    int? waterGoal,
    int? exerciseGoal,
    int? sleepGoal,
    int? calorieGoal,
  }) async {
    if (_user == null) return false;

    try {
      final updatedUser = _user!.copyWith(
        name: name,
        age: age,
        gender: gender,
        weight: weight,
        height: height,
        waterGoal: waterGoal,
        exerciseGoal: exerciseGoal,
        sleepGoal: sleepGoal,
        calorieGoal: calorieGoal,
        updatedAt: DateTime.now(),
      );

      await _userRepository.updateUser(updatedUser);
      _user = updatedUser;
      notifyListeners();

      return true;
    } catch (e) {
      _setError('Failed to update profile: $e');
      return false;
    }
  }

  Future<bool> deleteAccount() async {
    if (_firebaseUser == null) return false;

    try {
      _setState(AuthState.loading);

      // Delete user data from local database
      if (_user != null) {
        await _userRepository.deleteUser(_user!.id);
      }

      // Delete Firebase account
      if (FirebaseService.isInitialized) {
        await _firebaseUser!.delete();
      }

      _user = null;
      _firebaseUser = null;
      _setState(AuthState.unauthenticated);

      return true;
    } catch (e) {
      _setError('Failed to delete account: $e');
      return false;
    }
  }

  void _setState(AuthState state) {
    _state = state;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _state = AuthState.error;
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    if (_state == AuthState.error) {
      _state =
          _user != null ? AuthState.authenticated : AuthState.unauthenticated;
      _errorMessage = null;
      notifyListeners();
    }
  }

  String _getAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'weak-password':
        return 'Password is too weak. Please choose a stronger password.';
      case 'invalid-email':
        return 'Invalid email address format.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      default:
        return e.message ?? 'An authentication error occurred.';
    }
  }
}
