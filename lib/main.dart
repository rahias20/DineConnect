import 'package:dine_connect/firebase_options.dart';
import 'package:dine_connect/pages/about_page.dart';
import 'package:dine_connect/pages/account_page.dart';
import 'package:dine_connect/pages/appearance_page.dart';
import 'package:dine_connect/pages/change_email_page.dart';
import 'package:dine_connect/pages/change_password_page.dart';
import 'package:dine_connect/pages/chats_page.dart';
import 'package:dine_connect/pages/create_event_page1.dart';
import 'package:dine_connect/pages/create_event_page2.dart';
import 'package:dine_connect/pages/edit_profile_page1.dart';
import 'package:dine_connect/pages/edit_profile_page2.dart';
import 'package:dine_connect/components/event_content.dart';
import 'package:dine_connect/pages/forgot_password_page.dart';
import 'package:dine_connect/pages/help_and_support_page.dart';
import 'package:dine_connect/pages/home_page.dart';
import 'package:dine_connect/pages/chats_page.dart';
import 'package:dine_connect/pages/host_page.dart';
import 'package:dine_connect/pages/join_page.dart';
import 'package:dine_connect/pages/notifications_page.dart';
import 'package:dine_connect/pages/settings_page.dart';
import 'package:dine_connect/pages/welcome_page.dart';
import 'package:dine_connect/services/authentication/auth_gate.dart';
import 'package:dine_connect/services/authentication/login_or_register.dart';
import 'package:dine_connect/themes/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dine_connect/models/event.dart';

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
        '/welcomePage': (context) => WelcomePage(onTap: () {}),
        '/loginOrRegister': (context) => const LoginOrRegister(),
        '/homepage': (context) => HomePage(),
        '/editProfilePage1': (context) => const EditProfilePage1(),
        '/editProfilePage2': (context) => const EditProfilePage2(),
        '/chatsPage': (context) => const ChatsPage(),
        '/forgotPasswordPage': (context) => const ForgotPasswordPage(),
        '/createEvent1': (context) => const CreateEventPage1(),
        '/joinPage': (context) => const JoinPage(),
        '/hostPage': (context) => const HostPage(),
        '/settingsPage': (context) => const SettingsPage(),
        '/aboutPage': (context) => const AboutPage(),
        '/helpAndSupportPage': (context) => const HelpAndSupportPage(),
        '/appearancePage': (context) => const AppearancePage(),
        '/accountPage': (context) => const AccountPage(),
        '/notificationsPage': (context) => const NotificationsPage(),
        '/changePasswordPage': (context) => const ChangePasswordPage(),
        '/changeEmailPage': (context) => const ChangeEmailPage(),
        '/createEvent2': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Event;
          return CreateEventPage2(event: args);
        },
        '/eventContent': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return EventContent(
            event: args['event'] as Event,
            navbarButtonText: args['navbarButtonText'] as String,
            navbarButtonPressed: args['navbarButtonPressed'] as VoidCallback,
            onHostClicked: args['onHostClicked'] as VoidCallback,
          );
        },
      },
    );
  }
}
