import 'package:dine_connect/components/my_text_form_field.dart';
import 'package:dine_connect/components/my_textfield.dart';
import 'package:dine_connect/services/authentication/auth_service.dart';
import 'package:flutter/material.dart';

import '../components/my_button.dart';

class LoginPage extends StatefulWidget {
  void Function()? onTap;

  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  const SizedBox(height: 30),
                  // logo
                  const SizedBox(
                    width: 900,
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

                  // welcome back message
                  const SizedBox(height: 30),
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
                  const SizedBox(height: 25),
                  MyTextFormField(
                      key: const Key('emailField'),
                      obscureText: false,
                      controller: _emailController,
                      labelText: 'Email',
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !value.contains('@')) {
                          return 'Invalid email';
                        }
                        return null;
                      }),

                  // password text field
                  const SizedBox(height: 25),
                  MyTextFormField(
                    key: const Key("passwordField"),
                    obscureText: true,
                    controller: _passwordController,
                    labelText: 'Password',
                    validator: (value){
                      if (value == null || value.isEmpty){
                        return 'Please enter a password';
                      }
                    },
                  ),

                  // forgot password
                  const SizedBox(height: 9),
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
                  const SizedBox(height: 25),
                  MyButton(
                      text: "Login",
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          login(context);
                        }
                      }),

                  // register now
                  const SizedBox(height: 25),
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
    // get auth service
    final authService = AuthService();
    try {
      await authService.signInWithEmailPassword(
          _emailController.text, _passwordController.text);
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
