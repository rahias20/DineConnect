import 'dart:io';
import 'package:dine_connect/components/my_text_form_field.dart';
import 'package:dine_connect/components/my_textfield.dart';
import 'package:flutter/material.dart';

import '../models/user_profile.dart';
import '../services/userProfile/user_profile_service.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  UserProfile? _userProfile;
  late UserProfileService _userProfileService;

  // TextEditingControllers
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _bioController;
  late TextEditingController _lookingForController;
  late TextEditingController _hobbyController;
  late TextEditingController _locationController;
  String imageUrl = '';
  List<String> hobbies = [];
  bool _isLocationServiceEnabled = false;

  @override
  void initState() {
    super.initState();
    _userProfileService = UserProfileService();

    // initialize the controllers
    _nameController = TextEditingController();
    _ageController = TextEditingController();
    _bioController = TextEditingController();
    _lookingForController = TextEditingController();
    _hobbyController = TextEditingController();
    _locationController = TextEditingController();

    // fetch user profile
    _fetchUserProfile();

  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _bioController.dispose();
    _lookingForController.dispose();
    _hobbyController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserProfile() async {
    try {
      UserProfile? profile = await _userProfileService.fetchUserProfile();

      if (profile != null) {
        setState(() {
          _userProfile = profile;

          // assign values to controller
          _nameController.text = _userProfile?.name ?? '';
          _ageController.text = _userProfile?.age.toString() ?? '';
          _locationController.text = _userProfile?.location ?? '';
          _bioController.text = _userProfile?.bio ?? '';
          _lookingForController.text = _userProfile?.lookingFor ?? '';
          _hobbyController.text = _userProfile?.hobbies.join(', ') ?? '';
        });
      }
    } catch (e) {
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
          title: const Text("Profile"),
          centerTitle: true,
          backgroundColor: colorScheme.primary,
        ),
        body: Column(
          children: [
            SizedBox(height: screenHeight * 0.04),
            MyTextFormField(
              controller: _nameController,
              labelText: 'Name',
              validator: (value) {
                if (value == null) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),

            SizedBox(height: screenHeight * 0.04),
            MyTextFormField(
              controller: _ageController,
              labelText: 'Age',
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null) {
                  return 'Please enter your age';
                }
                return null;
              },
            ),

            SizedBox(height: screenHeight * 0.04),
            MyTextFormField(
              controller: _bioController,
              labelText: 'Bio',
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null) {
                  return 'Please enter your bio';
                }
                return null;
              },
            ),

            SizedBox(height: screenHeight * 0.04),
            MyTextFormField(
              controller: _lookingForController,
              labelText: 'What are you looking for . . .',
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null) {
                  return 'Please enter what are you looking for';
                }
                return null;
              },
            ),


            SizedBox(height: screenHeight * 0.1),
            Text(_userProfile!.name),

          ],
        ));
  }

  Widget _infoCard(
      String title, String content, double screenHeight, double screenWidth) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05, vertical: screenHeight * 0.01),
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

  Widget _hobbiesWrap(
      List<String> hobbies, double screenHeight, double screenWidth) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.05),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 4.0,
        children: hobbies
            .map((hobby) => Chip(
                  label: Text(hobby),
                  backgroundColor: colorScheme.secondary,
                ))
            .toList(),
      ),
    );
  }
}
