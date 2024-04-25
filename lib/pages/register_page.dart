import 'package:dine_connect/components/my_text_form_field.dart';
import 'package:dine_connect/pages/complete_profile_page.dart';
import 'package:dine_connect/services/authentication/auth_service.dart';
import 'package:flutter/material.dart';

import '../components/my_button.dart';

// Stateful widget to handle registration page and redirect to profile page
class RegisterPage extends StatefulWidget {
  void Function()? onTap;

  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Text controllers to control input fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Regular expression pattern for email validation.
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);

    // Accessing device's screen height and theme colour scheme.
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Center(
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // logo
                  SizedBox(height: screenHeight * 0.02),
                  const SizedBox(
                    width: 500,
                    child: AspectRatio(
                      aspectRatio:
                          3, // This is the aspect ratio of the container, change it as needed
                      child: Image(
                        image: AssetImage('lib/images/logo.png'),
                        fit: BoxFit
                            .contain, // This will contain the image within the container's bounds
                      ),
                    ),
                  ),

                  // Header text encouraging user to create an account.
                  SizedBox(height: screenHeight * 0.03),
                  Text(
                    "Let's create an account for you",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 20),
                  ),

                  // Email input field
                  SizedBox(height: screenHeight * 0.035),
                  MyTextFormField(
                    key: const Key("emailField"),
                    labelText: 'Email',
                    obscureText: false,
                    controller: _emailController,
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

                  // Password input field
                  SizedBox(height: screenHeight * 0.035),
                  MyTextFormField(
                    key: const Key("passwordField"),
                    labelText: 'Password',
                    obscureText: true,
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters long';
                      }
                      return null;
                    },
                  ),

                  // password requirements message
                  SizedBox(height: screenHeight * 0.02),
                  const Text(
                    'Password must be at least 8 characters long',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 12,
                    ),
                  ),

                  // Confirm password input field
                  SizedBox(height: screenHeight * 0.035),
                  MyTextFormField(
                    key: const Key("confirmPasswordField"),
                    labelText: 'Confirm Password',
                    obscureText: true,
                    controller: _confirmPasswordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),

                  // Button to submit registration
                  SizedBox(height: screenHeight * 0.03),
                  MyButton(
                    text: "Register",
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        register(context);
                      }
                    },
                  ),

                  // Link to switch to login if already a member.
                  SizedBox(height: screenHeight * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already a member? ",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary)),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          "Login now",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Function to handle registration logic using AuthService.
  void register(context) async {
    // get auth service
    final _auth = AuthService();
    try {
      await _auth.signUpWithEmailPassword(
          _emailController.text, _passwordController.text);

      // Navigate to CompleteProfilePage after successful registration.
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const CompleteProfilePage()),
          (Route<dynamic> route) => false);
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
        ),
      );
    }
  }
}
