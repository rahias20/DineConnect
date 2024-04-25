import 'package:flutter/material.dart';

// A StatelessWidget that creates a text field specifically designed for inputting items into a list.
class MyListField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final void Function(String) onSubmitted;

  // Constructor with named parameters for initializing the text field properties.
  const MyListField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
      child: TextField(
        // Attaching the controller that manages the text being edited
        controller: controller,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
          hintText: hintText,
        ),
        // Function that is called when the user submits their input
        onSubmitted: (value) {
          onSubmitted(value);
          controller.clear();
        },
      ),
    );
  }
}
