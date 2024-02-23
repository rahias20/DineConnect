import 'package:flutter/material.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';

class RegisterPage extends StatelessWidget {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  void Function()? onTap;

  RegisterPage({super.key});


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
              // welcome back message
              const SizedBox(height: 25),
              Text(
                "Let's create an account for you",
                style: TextStyle(
                    color: Theme
                        .of(context)
                        .colorScheme
                        .primary, fontSize: 16),
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

              // confirm password field
              const SizedBox(height: 25),
              MyTextField(
                  hintText: "Confirm password",
                  obscureText: true,
                  controller: _confirmPasswordController),

              // register button
              const SizedBox(height: 25),
              MyButton(text: "Register", onTap: (){}),

                            // register now
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already a member? ",
                      style: TextStyle(
                          color: Theme
                              .of(context)
                              .colorScheme
                              .primary)),
                  GestureDetector(
                    onTap: onTap,
                    child: Text(
                      "Login now",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme
                              .of(context)
                              .colorScheme
                              .primary),
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
}
