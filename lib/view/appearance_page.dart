import 'package:dine_connect/themes/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppearancePage extends StatelessWidget {
  const AppearancePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Appearance'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: colorScheme.secondary,
          borderRadius:
              BorderRadius.circular(12), // Rounded corners for the container
        ),
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // Space out child widgets equally
          children: [
            const Text('Dark Mode'),
            CupertinoSwitch(
              value: Provider.of<ThemeProvider>(context, listen: false)
                  .isDarkMode, // Get the current theme state
              onChanged: (value) =>
                  Provider.of<ThemeProvider>(context, listen: false)
                      .toggleTheme(), // Toggle theme on change
            ),
          ],
        ),
      ),
    );
  }
}
