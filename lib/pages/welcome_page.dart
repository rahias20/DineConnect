import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                const Text("DineConnect"),
                const Text(
                    "Welcome to DineConnect, where every meal is a chance to meet, share, and create lasting memories"),
                const Image(image: AssetImage("lib/images/logo.png")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/loginOrRegister');
                    },
                    child: const Text("Get Started",))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
