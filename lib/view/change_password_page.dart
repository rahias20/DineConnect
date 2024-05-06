import 'package:dine_connect/components/my_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Widget to manage password change in the app
class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>(); // Key for form validation
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String _errorMessage = '';

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _changePassword() async {
    // Validate before proceeding
    if (_formKey.currentState!.validate()) {
      try {
        User? user = FirebaseAuth.instance.currentUser;
        String email = user!.email!;

        // Re-authenticate the user
        AuthCredential credential = EmailAuthProvider.credential(
            email: email, password: _oldPasswordController.text);

        await user.reauthenticateWithCredential(credential);

        // Change password
        await user.updatePassword(_newPasswordController.text);

        // Clear the fields
        _oldPasswordController.clear();
        _newPasswordController.clear();

        // Show success dialog
        _showEventCreatedDialogAndNavigate();
      } catch (error) {
        setState(() {
          _errorMessage = error.toString();
        });
      }
    }
  }

  void _showEventCreatedDialogAndNavigate() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('Password changed successfully'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Icon(Icons.check_circle, color: Colors.green, size: 70),
              ],
            ),
          ),
        );
      },
    );
    // Auto-close the dialog after 2 seconds and navigate back
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.09),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: _oldPasswordController,
                  obscureText: true,
                  decoration:
                      const InputDecoration(labelText: 'Current Password'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your current password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'New Password'),
                  // Ensure new password is at least 8 characters long.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a new password';
                    } else if (value.length < 8) {
                      return 'Password must be at least 8 characters long';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration:
                      const InputDecoration(labelText: 'Confirm Password'),
                  // Check if confirmed password matches the new password.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),
                const SizedBox(height: 50),
                MyButton(
                  onTap: _changePassword,
                  text: 'Change Password',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
