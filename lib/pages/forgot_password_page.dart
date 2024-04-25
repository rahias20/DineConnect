import 'package:dine_connect/components/my_button.dart';
import 'package:dine_connect/components/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Widget to handle password reset functionality
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // Asynchronous function to send password reset email
  Future _passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());

      if (!mounted) return; // Check if the widget is still in the tree

      // Clear the text field and show a dialog on successful email submission
      _emailController.clear();
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text('Password reset link sent',
                  style: TextStyle(fontSize: 22)),
            );
          });
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                    'Enter your Email and we will send you a password reset link',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20)),
              ),
              const SizedBox(height: 10),
              MyTextField(
                  hintText: 'Email',
                  obscureText: false,
                  controller: _emailController),
              const SizedBox(height: 20),
              MyButton(text: 'Reset Password', onTap: () => _passwordReset()),
            ],
          ),
        ),
      ),
    );
  }
}
