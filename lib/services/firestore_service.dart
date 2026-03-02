// lib/services/firestore_service.dart
//
// FirestoreService handles all Firestore database writes for the app.
// Keeping Firestore logic here (not inside screens) makes the code
// much cleaner and easier to maintain.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  // Singleton
  static final FirestoreService _instance = FirestoreService._internal();
  factory FirestoreService() => _instance;
  FirestoreService._internal();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ── Save a contact form lead ───────────────────────────────────────────────
  //
  // This is called AFTER EmailJS sends the email, so we have dual coverage:
  //   1. EmailJS  → admin gets notified instantly by email
  //   2. Firestore → lead is permanently stored in your database
  //
  // Returns true on success, false on failure.
  // We never throw here — failure is logged silently so the user
  // still sees a success message (the email already went through).
  Future<bool> saveLead({
    required String name,
    required String email,
    required String phone,
    required String serviceRequested,
    required String message,
  }) async {
    try {
      // Get the logged-in user's UID if available.
      // If user isn't logged in, userId will be null — that's fine.
      final String? userId = _auth.currentUser?.uid;

      await _db.collection('leads').add({
        'name':             name.trim(),
        'email':            email.trim().toLowerCase(),
        'phone':            phone.trim(),
        'serviceRequested': serviceRequested,
        'message':          message.trim().isEmpty ? '' : message.trim(),
        'userId':           userId,          // null if not logged in
        'createdAt':        FieldValue.serverTimestamp(),
        'status':           'new',           // useful for CRM-style filtering
        'source':           'mobile_app',
      });

      return true;
    } catch (e) {
      // Log for debugging but don't crash the app
      debugFirestore('saveLead error: $e');
      return false;
    }
  }

  // Simple debug logger (only prints in debug mode)
  void debugFirestore(String message) {
    assert(() {
      // ignore: avoid_print
      print('[FirestoreService] $message');
      return true;
    }());
  }
}