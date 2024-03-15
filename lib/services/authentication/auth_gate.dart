
import 'package:dine_connect/pages/create_event_page1.dart';
import 'package:dine_connect/pages/location_search_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dine_connect/services/authentication/welcome_or_login_or_register.dart';

import '../../pages/home_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          // user is logged in
          if (snapshot.hasData){
            return LocationSearchPage();
          }else{
            return WelcomeOrLoginOrRegister();
          }

          // user is not logged in
        },
      ),
    );
  }
}