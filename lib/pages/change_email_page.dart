import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/my_button.dart';

class ChangeEmailPage extends StatefulWidget {
  const ChangeEmailPage({super.key});

  @override
  State<ChangeEmailPage> createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _reauthenticateAndChangeEmail() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Get current user
        User? user = FirebaseAuth.instance.currentUser;
        // Get auth credentials
        final cred = EmailAuthProvider.credential(
            email: user!.email!, password: _passwordController.text);
        // Reauthenticate
        await user.reauthenticateWithCredential(cred);
        // Update email
        await user.verifyBeforeUpdateEmail(_emailController.text);

        if (!mounted) return;

        _emailController.clear();
        _passwordController.clear();
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                content: Text(
                  'Email update link sent',
                  style: TextStyle(fontSize: 22),
                ),
              );
            });

        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pop();
        });

        // Navigator.of(context).pop();
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update email: ${e.message}')),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Email'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.09),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'New Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  // Regular expression pattern for validating email format
                  if (!regex.hasMatch(value)) {
                    return 'Invalid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 25),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (value) {
                  return value!.isEmpty ? 'Please enter your password' : null;
                },
                obscureText: true,
              ),
              const SizedBox(height: 40),
              MyButton(
                onTap: _reauthenticateAndChangeEmail,
                text: 'Change Password',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
