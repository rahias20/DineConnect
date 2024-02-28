import 'package:dine_connect/firebase_options.dart';
import 'package:dine_connect/pages/home_page.dart';
import 'package:dine_connect/services/authentication/auth_gate.dart';
import 'package:dine_connect/services/authentication/login_or_register.dart';
import 'package:dine_connect/themes/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AuthGate(),
      theme: Provider.of<ThemeProvider>(context).themeData,
      routes: {
        '/loginOrRegister': (context) => LoginOrRegister(),
        '/homepage': (context) => HomePage(),

      },

    );
  }
}
