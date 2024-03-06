import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_connect/models/user_profile.dart';
import 'package:dine_connect/services/authentication/auth_service.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final AuthService _authService = AuthService();
  UserProfile? _userProfile;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      String userId = _authService.getCurrentUser()!.uid;
      DocumentSnapshot userProfileSnapshot = await FirebaseFirestore.instance
          .collection('userProfiles')
          .doc(userId)
          .get();

      if (userProfileSnapshot.exists) {
        setState(() {
          _userProfile = UserProfile.fromMap(userProfileSnapshot.data() as Map<String, dynamic>);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error fetching user profile: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
      ),
      body: _userProfile == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.04),
              CircleAvatar(
                radius: screenHeight * 0.1,
                backgroundImage: _userProfile!.imageUrl!.isNotEmpty
                    ? FileImage(File(_userProfile!.imageUrl.toString()))
                    : const AssetImage('lib/images/profile_icon.png') as ImageProvider,
                backgroundColor: Colors.white60,
              ),
              SizedBox(height: screenHeight * 0.03),
              Text(
                "${_userProfile!.name}, ${_userProfile!.age}",
                style: TextStyle(
                  fontSize: screenHeight * 0.025, // Dynamic font size
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),

              SizedBox(height: screenHeight * 0.02),
              Text(
                _userProfile!.location,
                style: TextStyle(
                  fontSize: screenHeight * 0.025, // Dynamic font size
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),

              SizedBox(height: screenHeight * 0.02),
              _infoCard("Bio", _userProfile!.bio, screenHeight, screenWidth),
              _infoCard("Looking For", _userProfile!.lookingFor, screenHeight, screenWidth),
              _hobbiesWrap(_userProfile!.hobbies, screenHeight, screenWidth),
              SizedBox(height: screenHeight * 0.05),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoCard(String title, String content, double screenHeight, double screenWidth) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.01),
      child: Padding(
        padding: EdgeInsets.all(screenHeight * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: screenHeight * 0.022,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              content,
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: screenHeight * 0.02),
            ),
          ],
        ),
      ),
    );
  }

  Widget _hobbiesWrap(List<String> hobbies, double screenHeight, double screenWidth) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.05),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 4.0,
        children: hobbies.map((hobby) => Chip(
          label: Text(hobby),
          backgroundColor: colorScheme.secondary,
        )).toList(),
      ),
    );
  }
}
