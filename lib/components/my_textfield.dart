import 'package:flutter/material.dart';

// Custom TextField widget for consistent styling and functionality across the app.
class MyTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final bool isError;
  final bool enabled;
  final TextEditingController controller;

  const MyTextField(
      {super.key,
      this.enabled = true,
      required this.hintText,
      required this.obscureText,
      required this.controller,
      this.isError = false});

  @override
  Widget build(BuildContext context) {
    // Padding for uniform spacing around the text field
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        enabled: enabled,
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.tertiary)),
          focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.primary)),
          fillColor: Theme.of(context).colorScheme.secondary,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
          errorText: isError ? 'This field cannot be empty' : null,
        ),
      ),
    );
  }
}
