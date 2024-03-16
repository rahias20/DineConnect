import 'package:flutter/material.dart';

class NavbarButton extends StatelessWidget {
  final void Function() onPressed;
  final String buttonText;
  final double buttonWidthFactor;

  const NavbarButton(
      {super.key,
      required this.onPressed,
      required this.buttonText,
      this.buttonWidthFactor = 2});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: screenWidth * 0.1, vertical: 20),
      child: SizedBox(
        width: screenWidth /
            buttonWidthFactor, // use the screen width divided by the factor
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
            textStyle: TextStyle(fontSize: screenWidth * 0.05),
          ),
          child: Text(buttonText),
        ),
      ),
    );
  }
}
