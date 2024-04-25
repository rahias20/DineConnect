import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text; // Button text
  final VoidCallback onTap; // Function triggered when button pressed

  const MyButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: screenWidth * 0.9,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          elevation: 2,
          backgroundColor:
              colorScheme.secondary, // primary is the background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(25), // padding is inside the style
        ),
        child: Center(
          child: Text(text),
        ),
      ),
    );
  }
}
