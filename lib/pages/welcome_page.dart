import 'package:dine_connect/services/authentication/login_or_register.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  // tap to go to login or register page
  void Function()? onTap;
  WelcomePage({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
                    onTap: onTap,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(20.0), // Rounded corners
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
