import 'package:dine_connect/components/event_content.dart';
import 'package:dine_connect/controller/authentication/auth_gate.dart';
import 'package:dine_connect/controller/authentication/login_or_register.dart';
import 'package:dine_connect/firebase_options.dart';
import 'package:dine_connect/models/event.dart';
import 'package:dine_connect/themes/theme_provider.dart';
import 'package:dine_connect/view/about_page.dart';
import 'package:dine_connect/view/account_page.dart';
import 'package:dine_connect/view/appearance_page.dart';
import 'package:dine_connect/view/change_email_page.dart';
import 'package:dine_connect/view/change_password_page.dart';
import 'package:dine_connect/view/chat_page.dart';
import 'package:dine_connect/view/chats_page.dart';
import 'package:dine_connect/view/complete_profile_page.dart';
import 'package:dine_connect/view/create_event_page1.dart';
import 'package:dine_connect/view/create_event_page2.dart';
import 'package:dine_connect/view/edit_profile_page1.dart';
import 'package:dine_connect/view/edit_profile_page2.dart';
import 'package:dine_connect/view/forgot_password_page.dart';
import 'package:dine_connect/view/help_and_support_page.dart';
import 'package:dine_connect/view/home_page.dart';
import 'package:dine_connect/view/host_page.dart';
import 'package:dine_connect/view/host_profile_page.dart';
import 'package:dine_connect/view/join_page.dart';
import 'package:dine_connect/view/notifications_page.dart';
import 'package:dine_connect/view/settings_page.dart';
import 'package:dine_connect/view/welcome_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/user_profile.dart';

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

  // this widget is the root of the application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
      theme: Provider.of<ThemeProvider>(context).themeData,
      routes: {
        '/welcomePage': (context) => WelcomePage(onTap: () {}),
        '/loginOrRegister': (context) => const LoginOrRegister(),
        '/completeProfilePage': (context) => const CompleteProfilePage(),
        '/homepage': (context) => const HomePage(),
        '/editProfilePage1': (context) => const EditProfilePage1(),
        '/editProfilePage2': (context) => const EditProfilePage2(),
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
        '/hostProfilePage': (context) {
          final arguments = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          final userProfile = arguments['userProfile'] as UserProfile;
          final event = arguments['eventId'] as String;
          return HostProfilePage(userProfile: userProfile, eventId: event);
        },
        '/createEvent2': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Event;
          return CreateEventPage2(event: args);
        },
        '/eventContent': (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return EventContent(
            event: args['event'] as Event,
            navbarButtonText: args['navbarButtonText'] as String,
            navbarButtonPressed: args['navbarButtonPressed'] as VoidCallback,
            onHostClicked: args['onHostClicked'] as VoidCallback,
          );
        },
        '/chatsPage': (context) {
          final eventId = ModalRoute.of(context)!.settings.arguments as String;
          return ChatsPage(eventId: eventId);
        },
        '/chatPage': (context) {
          final eventId = ModalRoute.of(context)!.settings.arguments as String;
          return ChatPage(eventId: eventId);
        },
      },
    );
  }
}
