// lib/features/auth/auth_wrapper.dart
//
// AuthWrapper sits between main.dart and the rest of the app.
// It listens to Firebase's auth state stream and automatically
// shows the right screen without any manual navigation.
//
// Flow:
//   App starts → AuthWrapper builds
//   → Firebase checks if user was previously logged in (persistent session)
//   → If YES → show MainScreen immediately (no login needed)
//   → If NO  → show AuthScreen
//   → When user logs in → stream emits User → switches to MainScreen
//   → When user logs out → stream emits null → switches back to AuthScreen

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../screens/main_screen.dart';
import 'auth_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      // Listen to Firebase auth state changes
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {

        // While Firebase is figuring out if there's a logged-in user,
        // show a blank screen with a loading spinner.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // If we have a user → go to the main app
        if (snapshot.hasData && snapshot.data != null) {
          return const MainScreen();
        }

        // No user → show the auth screen
        return const AuthScreen();
      },
    );
  }
}