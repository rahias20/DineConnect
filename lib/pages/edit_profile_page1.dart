import 'package:dine_connect/components/user_profile_content.dart';
import 'package:flutter/material.dart';

import '../models/user_profile.dart';
import '../services/authentication/auth_service.dart';
import '../services/user_profile_service.dart';

// Widget for displaying user profile data with edit button
class EditProfilePage1 extends StatefulWidget {
  const EditProfilePage1({super.key});

  @override
  State<EditProfilePage1> createState() => _EditProfilePage1State();
}

class _EditProfilePage1State extends State<EditProfilePage1> {
  final AuthService _authService = AuthService();
  UserProfile? _userProfile;
  late UserProfileService _userProfileService;
  bool _isLoading = true; // add a loading state

  @override
  void initState() {
    super.initState();
    _userProfileService = UserProfileService();
    _fetchUserProfile();
  }

  // Function to navigate to the second edit profile page and reload the profile after
  void _editProfile(BuildContext context) {
    Navigator.pushNamed(context, '/editProfilePage2')
        .then((_) => reloadUserProfile());
  }

  Future<void> _fetchUserProfile() async {
    String? uid = _authService.getCurrentUser()?.uid;
    if (uid != null) {
      try {
        UserProfile? profile = await _userProfileService.fetchUserProfile(uid);

        if (profile != null) {
          setState(() {
            _userProfile = profile; // Update the user profile state
            _isLoading = false; // Set loading to false once the data is fetched
          });
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
    return;
  }

  // Reload user profile
  void reloadUserProfile() async {
    await _fetchUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => _editProfile(context),
              child: const Text(
                "Edit",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : UserProfileContent(userProfile: _userProfile!),
    );
  }
}
