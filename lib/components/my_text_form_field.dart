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
    final theme = Theme.of(context);

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
          // Use the color scheme from the theme
          border: OutlineInputBorder(
            borderSide: BorderSide(color: theme.colorScheme.surface),
            borderRadius: BorderRadius.circular(8.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: theme.colorScheme.primary, width: 2.0),
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: theme.colorScheme.secondary, width: 2.5),
            borderRadius: BorderRadius.circular(8.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: theme.colorScheme.error, width: 2.0),
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: theme.colorScheme.error, width: 2.5),
            borderRadius: BorderRadius.circular(8.0),
          ),
          labelStyle: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 16.0,
          ),
          errorStyle: TextStyle(
            color: theme.colorScheme.error,
            fontSize: 14.0,
          ),
        ),
      ),
    );
  }
}