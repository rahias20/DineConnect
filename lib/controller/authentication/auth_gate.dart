import 'package:dine_connect/controller/authentication/welcome_or_login_or_register.dart';
import 'package:dine_connect/view/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Widget that acts as an authentication gate, deciding the initial
// route based on the user's authentication status
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    // Creates a scaffold widget as the root of this screen.
    return Scaffold(
      // StreamBuilder listens to the stream of authentication state changes.
      body: StreamBuilder(
        // Stream provided by FirebaseAuth that notifies about changes to the user's sign-in state.
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // If the snapshot contains user data, it means the user is logged in.
          if (snapshot.hasData) {
            return const HomePage();
          } else {
            // If the user is not logged in, navigate to the
            // WelcomeOrLoginOrRegister page to handle authentication.
            return const WelcomeOrLoginOrRegister();
          }

          // user is not logged in
        },
      ),
    );
  }
}
