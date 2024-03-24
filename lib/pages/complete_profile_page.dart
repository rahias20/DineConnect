import 'dart:io';

import 'package:dine_connect/components/my_button.dart';
import 'package:dine_connect/components/my_list_field.dart';
import 'package:dine_connect/components/my_text_form_field.dart';
import 'package:dine_connect/models/user_profile.dart';
import 'package:dine_connect/services/authentication/auth_gate.dart';
import 'package:dine_connect/services/authentication/auth_service.dart';
import 'package:dine_connect/services/user_profile_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({super.key});

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // get auth and userProfile service
  final AuthService _authService = AuthService();
  late UserProfileService _userProfileService;

  // controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _lookingForController = TextEditingController();
  final TextEditingController _hobbyController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  String image = '';
  String imageUrl = '';
  List<String> hobbies = [];

  // fields empty check
  bool _isHobbiesEmpty = false;
  bool _isLocationEmpty = false;
  bool _isImageEmpty = false;

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

  @override
  void initState() {
    super.initState();
    _userProfileService = UserProfileService();
  }

  // add hobby to the list
  void _addHobby(String hobby) {
    if (hobby.isNotEmpty && !hobbies.contains(hobby)) {
      setState(() {
        hobbies.add(hobby.trim());
      });
    }
  }

  // save user profile to database
  Future<void> _saveProfile() async {
    bool hasErrors = false;

    // Convert age input to integer and check if it's null (invalid input)
    int? age = int.tryParse(_ageController.text);

    // Check each field and update the state if any are empty
    setState(() {
      _isHobbiesEmpty = hobbies.isEmpty;
      _isImageEmpty = imageUrl.isEmpty;
    });

    hasErrors = _isHobbiesEmpty || _isImageEmpty;

    if (hasErrors) {
      if (_isImageEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red.shade500,
            content: const Text('Please upload a profile photo to continue')));
      }
      return;
    }
    final userProfile = UserProfile(
      userId: _authService.getCurrentUser()!.uid,
      name: _nameController.text,
      age: int.parse(_ageController.text),
      bio: _bioController.text,
      lookingFor: _lookingForController.text,
      hobbies: hobbies,
      imageUrl: imageUrl,
      location: _locationController.text.trim(),
      userEmail: _authService.getCurrentUser()!.email.toString(),
      joinedEventsIds: [],
    );

    // save the user profile to the database
    await _userProfileService.saveUserProfile(userProfile);

    // navigate to home page after completing profile
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => AuthGate()),
        (Route<dynamic> route) => false);
  }

  // select profile picture
  Future<void> selectAndUploadImage() async {
    final XFile? file = await _userProfileService.selectImage();
    if (file != null) {
      setState(() async {
        image = file.path;
        imageUrl =
            await _userProfileService.uploadImage(File(file!.path)) ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Complete Your Profile")),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(bottom: keyboardHeight),
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.04),
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundImage: image.isNotEmpty
                          ? FileImage(File(image))
                          : const AssetImage('lib/images/profile_icon.png')
                              as ImageProvider,
                      backgroundColor: Colors.white60,
                    ),
                    Positioned(
                      bottom: -13,
                      left: 95,
                      child: IconButton(
                        onPressed: () => selectAndUploadImage(),
                        icon: const Icon(Icons.add_a_photo),
                      ),
                    ),
                  ],
                ),

                // get name
                SizedBox(height: screenHeight * 0.04),
                MyTextFormField(
                  labelText: 'Full Name',
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),

                // get age
                SizedBox(height: screenHeight * 0.04),
                MyTextFormField(
                  labelText: 'Age',
                  keyboardType: TextInputType.number,
                  controller: _ageController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your age';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid age';
                    }
                    return null;
                  },
                ),

                // city textfield
                SizedBox(height: screenHeight * 0.04),
                MyTextFormField(
                  labelText: 'City',
                  controller: _locationController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your location';
                    }
                    return null;
                  },
                ),

                // bio
                SizedBox(height: screenHeight * 0.04),
                MyTextFormField(
                  labelText: 'Tell us a bit about yourself',
                  controller: _bioController,
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your bio';
                    }
                    return null;
                  },
                ),

                // looking for textfield
                SizedBox(height: screenHeight * 0.04),
                MyTextFormField(
                  labelText: 'What are you looking for',
                  controller: _lookingForController,
                  maxLines: 2,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please specify what you are looking for';
                    }
                    return null;
                  },
                ),

                // get hobbies
                SizedBox(height: screenHeight * 0.04),
                MyListField(
                  hintText: 'Enter a hobby',
                  controller: _hobbyController,
                  onSubmitted: _addHobby,
                ),
                // Display hobbies
                Wrap(
                  spacing: 8.0,
                  children: hobbies
                      .map((hobby) => Chip(
                            label: Text(hobby),
                            onDeleted: () {
                              setState(() {
                                hobbies.remove(hobby);
                              });
                            },
                          ))
                      .toList(),
                ),

                // conditionally display an error message if no hobbies
                if (_isHobbiesEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(0),
                      child: Text(
                        'Please add at least one hobby',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  ),

                SizedBox(height: screenHeight * 0.04),
                // save user profile
                MyButton(
                    text: 'Save Profile',
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        if (!_isHobbiesEmpty) {
                          _saveProfile();
                        }
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
