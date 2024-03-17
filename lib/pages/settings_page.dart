import 'package:dine_connect/services/authentication/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../components/navbar_button.dart';
import '../services/authentication/auth_gate.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});


  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    // list of settings options
    final List<Map<String, dynamic>> settingsOptions = [
      {
        'icon': Icons.person,
        'title': 'Account',
        'subtitle': 'Privacy, security, change password',
      },
      {
        'icon': Icons.palette,
        'title': 'Appearance',
        'subtitle': 'Theme',
      },
      {
        'icon': Icons.notifications,
        'title': 'Notifications',
        'subtitle': 'Message, event reminders',
      },
      {
        'icon': Icons.info_outline,
        'title': 'About',
        'subtitle': 'Learn more about DineConnect',
      },
    ];

    void signOutUser(){
      authService.signUserOut();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const AuthGate()),
              (Route<dynamic> route) => false);
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
      ),
      bottomNavigationBar: NavbarButton(
        onPressed: signOutUser,
        buttonText: 'Sign Out',
      ),

      body: ListView.separated(
        padding: EdgeInsets.all(16),
        itemCount: settingsOptions.length,
        itemBuilder: (BuildContext context, int index) {
          var item = settingsOptions[index];
          return ListTile(
            leading: Icon(item['icon'], color: colorScheme.onSurface),
            title: Text(item['title'],
                style: TextStyle(color: colorScheme.onSurface)),
            subtitle: Text(item['subtitle'],
                style:
                    TextStyle(color: colorScheme.onSurface.withOpacity(0.6))),
            onTap: () {
              // navigation or functionality for each option
              // Navigator.pushNamed(context, '/accountSettings');
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) =>
            Divider(thickness: 0),
      ),
    );
  }
}
