import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'DineConnect',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Text(
              'DineConnect brings food lovers together, enabling them to discover new dining experiences, create events, and make new friends. Our mission is to connect people through the love of food and the joy of sharing meals.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Support',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'Need help or have questions? Contact our support team for assistance.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Terms of Service',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5.0),
            Text(
              'By using DineConnect, you agree to our terms of service. These terms govern your use of our service and contain important information about your legal rights.',
              style: TextStyle(fontSize: 16.0),
            ),

            SizedBox(height: 24.0),
            Text(
              'Version 1.0.0',
              style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
