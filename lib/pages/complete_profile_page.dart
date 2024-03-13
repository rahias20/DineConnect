import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_connect/components/my_button.dart';
import 'package:dine_connect/components/my_list_field.dart';
import 'package:dine_connect/components/my_text_form_field.dart';
import 'package:dine_connect/components/my_textfield.dart';
import 'package:dine_connect/services/authentication/auth_gate.dart';
import 'package:dine_connect/services/userProfile/user_profile_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:dine_connect/models/user_profile.dart';
import 'package:dine_connect/services/authentication/auth_service.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import 'home_page.dart';

class ProfileCompletePage extends StatefulWidget {
  const ProfileCompletePage({super.key});

  @override
  State<ProfileCompletePage> createState() => _ProfileCompletePageState();
}

class _ProfileCompletePageState extends State<ProfileCompletePage> {
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
  String imageUrl = '';
  List<String> hobbies = [];
  bool _isLocationServiceEnabled = false;

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
    _checkLocationPermissionAndService();
    _listenLocationServiceStatus();
  }

  void _listenLocationServiceStatus() {
    Geolocator.getServiceStatusStream().listen((ServiceStatus status) {
      setState(() {
        _isLocationServiceEnabled = status == ServiceStatus.enabled;
      });
      if (_isLocationServiceEnabled) {
        // Optionally, do something when the location service is enabled, like fetching the current position
        _checkLocationPermissionAndService();
      }
    });
  }

  Future<void> _checkLocationPermissionAndService() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // location services are not enabled, prompt the user to enable

      if (!mounted) return;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Location Services Disabled"),
            content: const Text("Please enable location services to proceed."),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  // Open location settings
                  Geolocator.openLocationSettings();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever
      return;
    }

    // if permissions are granted, proceed to fetch and display location
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // test if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are disabled')));
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
      });
      return;
    }

    if (permission == LocationPermission.deniedForever) {
      // permissions are denied forever, handle appropriately
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Location permissions are permanently denied, we cannot request permissions')));
      });
      return;
    }

    // when we reach here, permissions are granted and we can continue
    // accessing the position of the device
    Position position = await Geolocator.getCurrentPosition();

    // get place
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks.first;
      setState(() {
        _locationController.text = "${place.locality}, ${place.country}";
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to get Location')));
    }
  }

  // add hobby to the list
  void _addHobby(String hobby) {
    if (hobby.isNotEmpty && !hobbies.contains(hobby)) {
      setState(() {
        hobbies.add(hobby);
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
      _isLocationEmpty = _locationController.text.isEmpty;
    });

    hasErrors =
        _isHobbiesEmpty ||
        _isLocationEmpty ||
        _isImageEmpty;

    if (hasErrors){
      if (_isImageEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red.shade500,
            content: const Text('Please upload a profile photo to continue')));
      }else if (_isLocationEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red.shade500,
            content: const Text('Click on the location field to get location')));
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
        location: _locationController.text);

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
      setState(() {
        imageUrl = file.path;
      });
    }
    await _userProfileService.uploadImage(File(file!.path));
  }

  // this method is called when the "location" TextField is tapped
  Future<void> _onLocationFieldTapped() async {
    await _checkLocationPermissionAndService();
    _listenLocationServiceStatus();
    // If the location services are enabled and permission is granted, fetch the location
    if (_isLocationServiceEnabled) {
      await _determinePosition();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Complete Your Profile")),
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
                        ? FileImage(File(imageUrl))
                        : const AssetImage('lib/images/profile_icon.png')
                            as ImageProvider,
                    backgroundColor: Colors.white60,
                  ),
                  Positioned(
                    bottom: -10,
                    left: 80,
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

              // location texfield
              SizedBox(height: screenHeight * 0.04),
              GestureDetector(
                onTap: _onLocationFieldTapped,
                child: AbsorbPointer(
                  child: MyTextFormField(
                    controller: _locationController,
                    labelText: 'Location',
                    readOnly: true,
                  ),
                ),
              ),

              // bio
              SizedBox(height: screenHeight * 0.04),
              MyTextFormField(
                labelText: 'Tell us a bit about yourself',
                controller: _bioController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a bio';
                  }
                  return null;
                },
              ),

              // looking for textfield
              SizedBox(height: screenHeight * 0.04),
              MyTextFormField(
                labelText: 'What are you looking for',
                controller: _lookingForController,
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
    );
  }
}
