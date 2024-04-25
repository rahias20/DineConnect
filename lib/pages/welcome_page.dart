import 'package:flutter/material.dart';

// Welcome page with short message
class WelcomePage extends StatelessWidget {
  // Callback function that will be triggered when the user taps on 'Get Started' button
  void Function()? onTap;

  // Constructor for the WelcomePage, requiring a function to be passed that handles what happens when the button is tapped.
  WelcomePage({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // MediaQuery provides information about the size of the display to adjust the sizing of the UI elements appropriately.
    final double screenHeight = MediaQuery.of(context).size.height;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // Sets the background color of the entire screen using the theme's background color.
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        width: double.infinity, // Container takes the full width of the screen.
        height:
            double.infinity, // Container takes the full height of the screen.
        // SafeArea ensures that the UI does not overlap with the operating system's critical areas like notches.
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.055),
                  Text(
                    "DineConnect",
                    style: TextStyle(
                        fontSize: screenHeight * 0.042,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                        fontFamily: 'Georgia'),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  Text(
                    "Welcome to DineConnect, where every meal is a chance to meet, share, and create lasting memories",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: screenHeight * 0.024,
                        color: Colors.black87,
                        fontFamily: 'Arial'),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  const Image(image: AssetImage("lib/images/logo.png")),
                  SizedBox(height: screenHeight * 0.09),
                  GestureDetector(
                    onTap:
                        onTap, // Triggers the passed function when the area is tapped.
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 24.0),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius:
                            BorderRadius.circular(20.0), // Rounded corners
                      ),
                      child: const Text(
                        "Get Started",
                        style: TextStyle(fontSize: 16.0, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
