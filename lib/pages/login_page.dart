import 'package:dine_connect/components/my_textfield.dart';
import 'package:flutter/material.dart';

import '../components/my_button.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // tap to go to register page
  void Function()? onTap;

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                      fontWeight: FontWeight.bold,),
                ),
              ),

              // email text field
              const SizedBox(height: 25),
              MyTextField(
                  hintText: "Email",
                  obscureText: false,
                  controller: _emailController),

              // password text field
              const SizedBox(height: 25),
              MyTextField(
                  hintText: "Password",
                  obscureText: true,
                  controller: _passwordController),

              // login button
              const SizedBox(height: 25),
              MyButton(text: "Login", onTap: () => login(context)),

              // register now
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Not a member? ",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary)),
                  GestureDetector(
                    onTap: onTap,
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
    );
  }

  // login method
  login(BuildContext context) {}
}
