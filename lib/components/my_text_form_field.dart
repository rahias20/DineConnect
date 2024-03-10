import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final int? maxLines;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const MyTextFormField(
      {super.key,
      required this.controller,
      required this.labelText,
      this.maxLines = 1,
      this.obscureText = false,
      this.keyboardType = TextInputType.text,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
