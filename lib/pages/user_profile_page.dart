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
  // get authentication service
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
          _userProfile = UserProfile.fromMap(
              userProfileSnapshot.data() as Map<String, dynamic>);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching user profile: $e")),
      );
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text("Profile")),
    body: _userProfile == null
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 64,
                  backgroundImage: _userProfile!.imageUrl!.isNotEmpty
                      ? FileImage(File(_userProfile!.imageUrl.toString()))
                      : const AssetImage('lib/images/profile_icon.png') as ImageProvider,
                  backgroundColor: Colors.white60,
                ),
                Text("Name: ${_userProfile!.name}"),
                Text("Age: ${_userProfile!.age}"),
                Text("Bio: ${_userProfile!.bio}"),
                Text("Looking For: ${_userProfile!.lookingFor}"),
                Text("Hobbies: ${_userProfile!.hobbies.join(", ")}"),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text(_userProfile!.imageUrl.toString()),
                ),
              ],
            ),
          ),
  );
}

}
