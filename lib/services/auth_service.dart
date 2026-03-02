// lib/services/auth_service.dart
//
// AuthService handles all Firebase Authentication operations.
// It wraps Firebase calls in clean methods with proper error handling,
// so the rest of the app never has to deal with raw Firebase exceptions.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ── Result wrapper ────────────────────────────────────────────────────────────
// Instead of throwing exceptions up to the UI, we return an AuthResult.
// This makes error handling in screens very simple:
//   if (result.success) { ... } else { showError(result.error); }

class AuthResult {
  final bool success;
  final String? error;
  final User? user;

  const AuthResult._({required this.success, this.error, this.user});

  // Factory for success
  factory AuthResult.ok(User user) =>
      AuthResult._(success: true, user: user);

  // Factory for failure
  factory AuthResult.fail(String message) =>
      AuthResult._(success: false, error: message);
}

// ── AuthService ───────────────────────────────────────────────────────────────
class AuthService {
  // Singleton so the whole app shares one instance
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── Current user (null if not logged in) ─────────────────────────────────
  User? get currentUser => _auth.currentUser;

  // ── Stream of auth state changes ─────────────────────────────────────────
  // Emits a User when logged in, null when logged out.
  // AuthWrapper listens to this to decide which screen to show.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ── Sign Up ───────────────────────────────────────────────────────────────
  // Creates a new Firebase Auth account, then stores the user profile
  // in Firestore under users/{uid}.
  Future<AuthResult> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // 1. Create the auth account
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final user = credential.user!;

      // 2. Update the display name in Firebase Auth
      await user.updateDisplayName(name.trim());

      // 3. Save the profile to Firestore
      // merge: true means if the document already exists (e.g. from a previous
      // failed attempt), we update it instead of overwriting.
      await _db.collection('users').doc(user.uid).set({
        'name':      name.trim(),
        'email':     email.trim().toLowerCase(),
        'createdAt': FieldValue.serverTimestamp(),
        'provider':  'email',
        'uid':       user.uid,
      }, SetOptions(merge: true));

      return AuthResult.ok(user);
    } on FirebaseAuthException catch (e) {
      return AuthResult.fail(_friendlyAuthError(e.code));
    } catch (e) {
      return AuthResult.fail('Something went wrong. Please try again.');
    }
  }

  // ── Sign In ───────────────────────────────────────────────────────────────
  Future<AuthResult> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return AuthResult.ok(credential.user!);
    } on FirebaseAuthException catch (e) {
      return AuthResult.fail(_friendlyAuthError(e.code));
    } catch (e) {
      return AuthResult.fail('Something went wrong. Please try again.');
    }
  }

  // ── Sign Out ──────────────────────────────────────────────────────────────
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // ── Convert Firebase error codes to friendly messages ─────────────────────
  // Firebase returns codes like "email-already-in-use" — not user-friendly.
  // We convert them here so screens just show a readable string.
  String _friendlyAuthError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'This email is already registered. Please log in.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-credential':
        return 'Email or password is incorrect.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait a moment and try again.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'network-request-failed':
        return 'No internet connection. Please check your network.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}