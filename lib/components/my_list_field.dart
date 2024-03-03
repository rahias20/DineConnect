import 'package:flutter/material.dart';

class MyListField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final void Function(String) onSubmitted;

  const MyListField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0, bottom: 10.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.tertiary),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
          fillColor: Theme.of(context).colorScheme.secondary,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        onSubmitted: (value) {
          onSubmitted(value);
          controller.clear();
        },
      ),
    );
  }
}
