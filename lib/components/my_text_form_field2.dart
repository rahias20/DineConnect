import 'package:flutter/material.dart';

// Custom TextFormField widget with extended functionality for form input.
class MyTextFormField2 extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final int? maxLines;
  final bool obscureText;
  final bool readOnly;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;

  const MyTextFormField2({
    super.key,
    required this.controller,
    required this.labelText,
    this.maxLines = 1,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.readOnly = false,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType, // Defines the type of keyboard to show
      validator: validator,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        border: InputBorder.none,
        // focusedBorder: OutlineInputBorder(
        //   borderSide: BorderSide(color: theme.colorScheme.secondary, width: 2.5),
        //   borderRadius: BorderRadius.circular(8.0),
        // ),
      ),
    );
  }
}
