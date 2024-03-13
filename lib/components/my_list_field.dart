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
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
      child: TextField(
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
        onSubmitted: (value) {
          onSubmitted(value);
          controller.clear();
        },
      ),
    );
  }
}
