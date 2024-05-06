import 'dart:io';

import 'package:dine_connect/components/my_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../components/my_list_field.dart';
import '../controller/authentication/auth_service.dart';
import '../controller/user_profile_service.dart';
import '../models/user_profile.dart';

// Widget for managing editing of user profile
class EditProfilePage2 extends StatefulWidget {
  const EditProfilePage2({super.key});

  @override
  State<EditProfilePage2> createState() => _EditProfilePage2State();
}

class _EditProfilePage2State extends State<EditProfilePage2> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // get auth service
  final AuthService _authService = AuthService();
  UserProfile? _userProfile;
  late UserProfileService _userProfileService;

  // Controllers for form fields
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _bioController;
  late TextEditingController _lookingForController;
  late TextEditingController _hobbyController;
  late TextEditingController _locationController;
  String image = '';
  String imageUrl = '';
  String temUrl = '';
  List<String> hobbies = [];

  // fields empty check
  bool _isHobbiesEmpty = false;
  bool _isImageEmpty = false;

  @override
  void initState() {
    super.initState();
    _userProfileService = UserProfileService();

    // initialize the controllers with existing user data
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
    String? uid = _authService.getCurrentUser()?.uid;
    try {
      UserProfile? profile = await _userProfileService.fetchUserProfile(uid!);

      if (profile != null) {
        setState(() {
          _userProfile = profile;

          // assign values to controller
          _nameController.text = _userProfile?.name ?? '';
          _ageController.text = _userProfile?.age.toString() ?? '';
          _locationController.text = _userProfile?.location ?? '';
          _bioController.text = _userProfile?.bio ?? '';
          _lookingForController.text = _userProfile?.lookingFor ?? '';
          // _hobbyController.text = _userProfile?.hobbies.join(', ') ?? '';
          imageUrl = _userProfile?.imageUrl ?? '';
          temUrl = _userProfile?.imageUrl ?? '';
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  // Save updated user profile to database
  Future<void> _saveProfile() async {
    bool hasErrors = false;
    // Convert age input to integer and check if it's null (invalid input)
    int? age = int.tryParse(_ageController.text);

    if (image.isEmpty) {
      imageUrl = temUrl;
    } else {
      imageUrl = await _userProfileService.uploadImage(File(image)) ?? '';
    }

    // Check each field and update the state if any are empty
    setState(() {
      _isHobbiesEmpty = _userProfile?.hobbies?.isEmpty ?? true;
      _isImageEmpty = imageUrl.isEmpty;
    });

    // check if any validation failed
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
        hobbies: _userProfile!.hobbies,
        imageUrl: imageUrl,
        location: _locationController.text.trim(),
        userEmail: _authService.getCurrentUser()!.email.toString(),
        joinedEventsIds: []);

    // save the user profile to the database
    await _userProfileService.updateUserProfile(userProfile);

    // navigate to home page after completing profile
    if (!mounted) return;
    Navigator.pop(context);
  }

  // select a new profile picture
  Future<void> selectAndUploadImage() async {
    final XFile? file = await _userProfileService.selectImage();
    if (file != null) {
      setState(() {
        image = file.path;
        imageUrl = '';
      });
    }
  }

  // add hobby to the list
  void _addHobby(String hobby) {
    if (hobby.isNotEmpty && !hobbies.contains(hobby)) {
      setState(() {
        hobbies.add(hobby.trim());
        _userProfile?.hobbies.add(hobby.trim());
      });
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  if (_userProfile!.hobbies.isNotEmpty) {
                    _saveProfile();
                  } else {
                    setState(() {
                      _isHobbiesEmpty = true;
                    });
                  }
                }
              },
              // Save button with gesture detector
              child: const Text(
                "Save",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.04),
              Stack(
                children: [
                  CircleAvatar(
                    radius: 64,
                    backgroundImage: imageUrl.isNotEmpty
                        ? NetworkImage(imageUrl)
                        : FileImage(File(image)) as ImageProvider,
                    backgroundColor: Colors.white60,
                  ),
                  Positioned(
                    bottom: -15,
                    left: 95,
                    child: IconButton(
                      onPressed: () => selectAndUploadImage(),
                      icon: const Icon(Icons.add_a_photo),
                    ),
                  ),
                ],
              ),
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

              // city
              SizedBox(height: screenHeight * 0.04),
              MyTextFormField(
                labelText: 'City',
                controller: _locationController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your bio';
                  }
                  return null;
                },
              ),

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

              SizedBox(height: screenHeight * 0.04),
              MyListField(
                  hintText: 'Enter a hobby',
                  controller: _hobbyController,
                  onSubmitted: _addHobby),

              Wrap(
                spacing: 8.0, // Gap between adjacent chips
                runSpacing: 4.0, // Gap between lines
                children: List<Widget>.generate(
                    _userProfile?.hobbies.length ?? 0, (int index) {
                  return Chip(
                    label: Text(_userProfile!.hobbies[index]),
                    onDeleted: () {
                      setState(() {
                        _userProfile!.hobbies.removeAt(index);
                      });
                    },
                  );
                }),
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

              SizedBox(height: screenHeight * 0.12),
            ],
          ),
        ),
      ),
    );
  }
}
