import 'dart:io';
import 'package:dine_connect/services/authentication/auth_service.dart';
import 'package:flutter/material.dart';

import '../models/user_profile.dart';
import '../services/userProfile/user_profile_service.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();
  UserProfile? userProfile;
  late UserProfileService _userProfileService;

  @override
  void initState() {
    super.initState();
    _userProfileService = UserProfileService();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      UserProfile? profile = await _userProfileService.fetchUserProfile();
      if (profile != null) {
        setState(() {
          userProfile = profile;
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Center(child: Text("Home Page")),
        leading: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/chatsPage');
                },
                icon: const Icon(Icons.chat_bubble_outline),),
        actions: [
          GestureDetector(
            onTap: (){
              Navigator.pushNamed(context, '/editProfilePage1');
            },
            child: CircleAvatar(
              backgroundImage: userProfile?.imageUrl != null
                  ? FileImage(File(userProfile!.imageUrl.toString()))
                  : const AssetImage('lib/images/profile_icon.png')
                      as ImageProvider,
              backgroundColor: Colors.white60,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_authService.getCurrentUser()!.email as String),
              IconButton(
                  onPressed: () => _authService.signUserOut(),
                  icon: const Icon(Icons.logout)),
              Text(
                "${userProfile?.name}, ${userProfile?.age}",
                style: TextStyle(
                  fontSize: screenHeight * 0.025, // Dynamic font size
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
