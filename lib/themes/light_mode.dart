import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
// Use ColorScheme to configure the color properties
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF607D8B), // DARK PRIMARY COLOR
    secondary: Color(
        0xFFFFFFFF), // You can choose a darker shade for the secondary variant
    surface: Color(
        0xFFFFFFFF), // Typically the background color for widgets like Card
    background: Color(0xFFCFD8DC), // LIGHT PRIMARY COLOR for background color
    error: Color(
        0xFFB00020), // Material design default error color, or choose your own
    onPrimary: Color(0xFFFFFFFF), // TEXT / ICONS color on top of primary color
    onSecondary: Color(
        0xFF000000), // Color for text on top of secondary color, choose as needed
    onSurface: Color(
        0xFF212121), // PRIMARY TEXT color for text on top of surface color
    onBackground:
    Color(0xFF212121), // PRIMARY TEXT color for text on background color
    onError: Color(0xFFFFFFFF), // Color for text on top of error color
  ),
);
