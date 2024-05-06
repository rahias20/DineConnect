import 'package:dine_connect/components/my_text_form_field.dart';
import 'package:dine_connect/controller/authentication/auth_service.dart';
import 'package:flutter/material.dart';

import '../components/my_button.dart';

// Stateful widget to manage login form.
class LoginPage extends StatefulWidget {
  void Function()? onTap;

  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers for text fields to handle user input.
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Dispose controllers when widget is removed to prevent memory leaks.
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Email validation pattern
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);

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
                  SizedBox(height: screenHeight * 0.03),
                  // logo
                  const SizedBox(
                    width: 900,
                    child: AspectRatio(
                      aspectRatio:
                          2.5, // This is the aspect ratio of the container, change it as needed
                      child: Image(
                        image: AssetImage('lib/images/logo.png'),
                        fit: BoxFit
                            .contain, // This will contain the image within the container's bounds
                      ),
                    ),
                  ),

                  // welcome back message
                  SizedBox(height: screenHeight * 0.04),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Sign in to your account",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // email text field
                  SizedBox(height: screenHeight * 0.03),
                  MyTextFormField(
                    key: const Key('emailField'),
                    obscureText: false,
                    controller: _emailController,
                    labelText: 'Email',
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

                  // password text field
                  SizedBox(height: screenHeight * 0.03),
                  MyTextFormField(
                    key: const Key("passwordField"),
                    obscureText: true,
                    controller: _passwordController,
                    labelText: 'Password',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                    },
                  ),

                  // forgot password
                  SizedBox(height: screenHeight * 0.01),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(
                              context, '/forgotPasswordPage'),
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // login button
                  SizedBox(height: screenHeight * 0.03),
                  MyButton(
                      text: "Login",
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          login(context);
                        }
                      }),

                  // register now
                  SizedBox(height: screenHeight * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Not a member? ",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary)),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          "Register now",
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

  // login
  void login(BuildContext context) async {
    // Get auth service
    final authService = AuthService();
    try {
      // Attempt to sig in with email and password
      await authService.signInWithEmailPassword(
          _emailController.text, _passwordController.text);
    } catch (e) {
      // Display error if login fails
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
        ),
      );
    }
  }
}
