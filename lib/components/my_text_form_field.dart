import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final int? maxLines;
  final bool obscureText;
  final bool readOnly;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const MyTextFormField(
      {super.key,
      required this.controller,
      required this.labelText,
      this.maxLines = 1,
      this.obscureText = false,
      this.keyboardType = TextInputType.text,
      this.validator,this.
      readOnly = false,
      });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        readOnly: readOnly,

        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
