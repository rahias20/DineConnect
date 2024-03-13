import 'dart:io';
import 'package:dine_connect/components/my_text_form_field.dart';
import 'package:dine_connect/components/my_textfield.dart';
import 'package:dine_connect/pages/user_profile_content.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import '../components/my_button.dart';
import '../components/my_list_field.dart';
import '../models/user_profile.dart';
import '../services/authentication/auth_service.dart';
import '../services/userProfile/user_profile_service.dart';
import 'package:path/path.dart' as path;

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

  // fields empty check
  bool _isNameEmpty = false;
  bool _isAgeEmpty = false;
  bool _isBioEmpty = false;
  bool _isLookingForEmpty = false;
  bool _isHobbiesEmpty = false;
  bool _isLocationEmpty = false;
  bool _isImageEmpty = false;

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
          // _hobbyController.text = _userProfile?.hobbies.join(', ') ?? '';
          imageUrl = _userProfile?.imageUrl ?? '';
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  // save user profile to database
  Future<void> _saveProfile() async {
    bool hasErrors = false;
    // Convert age input to integer and check if it's null (invalid input)
    int? age = int.tryParse(_ageController.text);

    // Check each field and update the state if any are empty
    setState(() {
      _isHobbiesEmpty = _userProfile?.hobbies?.isEmpty ?? true;
      _isLocationEmpty = _locationController.text.isEmpty;
      _isImageEmpty = imageUrl.isEmpty;
    });

    // check if any validation failed
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
        hobbies: _userProfile!.hobbies,
        imageUrl: imageUrl,
        location: _locationController.text);

    // save the user profile to the database
    await _userProfileService.updateUserProfile(userProfile);

    // navigate to home page after completing profile
    if (!mounted) return;
    Navigator.pop(context);
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

  Future<void> _checkLocationPermissionAndService() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // location services are not enabled, prompt the user to enable

      if (!mounted) return;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Location Services Disabled"),
            content: Text("Please enable location services to proceed."),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
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
      // Show a dialog or snackbar informing the user.
      return;
    }

    // if permissions are granted, proceed to fetch and display location
    _determinePosition();
  }

  // get location
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
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to get Location')));
    }
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

  // add hobby to the list
  void _addHobby(String hobby) {
    if (hobby.isNotEmpty && !hobbies.contains(hobby)) {
      setState(() {
        hobbies.add(hobby);
        _userProfile?.hobbies.add(hobby);
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
                  }
                }
              },
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
                        ? FileImage(File(imageUrl))
                        : const AssetImage('lib/images/profile_icon.png')
                            as ImageProvider,
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

              // location
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

              SizedBox(height: screenHeight * 0.04),
              MyTextFormField(
                labelText: 'Tell us a bit about yourself',
                controller: _bioController,
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
                children: List<Widget>.generate(_userProfile?.hobbies.length ?? 0,
                    (int index) {
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
