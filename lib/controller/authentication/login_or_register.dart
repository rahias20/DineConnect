import 'package:flutter/material.dart';

import '../../view/login_page.dart';
import '../../view/register_page.dart';

// Declaring a StatefulWidget to manage dynamic content based on user interaction.
class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  // Boolean variable to determine which page to show: login or register.
  // Initially set to true to show the login page first.
  bool showLoginPage = true;

  // Function to toggle the boolean state, which in turn toggles the displayed page.
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Conditionally return a page based on the value of `showLoginPage`.
    if (showLoginPage) {
      // Show login page and provide method to toggle.
      return LoginPage(
        onTap: togglePages,
      );
    } else {
      // Show register page and provide method to toggle.
      return RegisterPage(
        onTap: togglePages,
      );
    }
  }
}
