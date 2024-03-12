import 'package:dine_connect/components/my_textfield.dart';
import 'package:dine_connect/firebase_options.dart';
import 'package:dine_connect/pages/chats_page.dart';
import 'package:dine_connect/pages/edit_profile_page1.dart';
import 'package:dine_connect/pages/edit_profile_page2.dart';
import 'package:dine_connect/pages/forgot_password_page.dart';
import 'package:dine_connect/pages/home_page.dart';
import 'package:dine_connect/pages/chats_page.dart';
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
        '/loginOrRegister': (context) => const LoginOrRegister(),
        '/homepage': (context) => HomePage(),
        '/editProfilePage1': (context) => const EditProfilePage1(),
        '/editProfilePage2': (context) => const EditProfilePage2(),
        '/chatsPage': (context) => const ChatsPage(),
        '/forgotPasswordPage': (context) => const ForgotPasswordPage(),

      },

    );
  }
}
