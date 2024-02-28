import 'package:dine_connect/pages/welcome_page.dart';
import 'package:dine_connect/services/authentication/login_or_register.dart';
import 'package:flutter/material.dart';

import '../../pages/login_page.dart';
import '../../pages/register_page.dart';

class WelcomeOrLoginOrRegister extends StatefulWidget {
  const WelcomeOrLoginOrRegister({super.key});

  @override
  State<WelcomeOrLoginOrRegister> createState() => _WelcomeOrLoginOrRegisterState();
}

class _WelcomeOrLoginOrRegisterState extends State<WelcomeOrLoginOrRegister> {

  // initially show login page
  bool showLoginPage = false;

  // toggle between login and register page
  void togglePages(){
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage){
      return LoginOrRegister();
    }else{
      return WelcomePage(onTap: togglePages,);
    }
  }
}
