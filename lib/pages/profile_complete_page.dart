import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_connect/components/my_button.dart';
import 'package:dine_connect/components/my_list_field.dart';
import 'package:dine_connect/components/my_textfield.dart';
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
  // get auth service
  final AuthService _authService = AuthService();

  // controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _lookingForController = TextEditingController();
  final TextEditingController _hobbyController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  String imageUrl = '';
  List<String> hobbies = [];
  String? _locationMessage;
  bool _isLocationServiceEnabled = false;


  // fields empty check
  bool _isNameEmpty = false;
  bool _isAgeEmpty = false;
  bool _isBioEmpty = false;
  bool _isLookingForEmpty = false;
  bool _isHobbiesEmpty = false;
  bool _isLocationEmpty = false;

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
    _checkLocationPermissionAndService();
    _listenLocationServiceStatus();
  }

  Future<void> _checkLocationService() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    setState(() {
      _isLocationServiceEnabled = serviceEnabled;
    });
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

  Future<void> _checkLocationPermissionAndService() async{
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled){
      // location services are not enabled, prompt the user to enable
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



  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // test if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _locationMessage = 'Location services are disabled.';
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are disabled')));

      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied){
      setState(() {
        _locationMessage = 'Location permissions are denied';
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
      });
      return;
    }

    if (permission == LocationPermission.deniedForever) {
      // permissions are denied forever, handle appropriately
      setState(() {
        _locationMessage =
            'Location permissions are permanently denied, we cannot request permissions';
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are permanently denied, we cannot request permissions')));
      });
      return;
    }

    // when we reach here, permissions are granted and we can continue
    // accessing the position of the device
    Position position = await Geolocator.getCurrentPosition();

    // get place
    try{
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks.first;
      setState(() {
        _locationMessage = "${place.locality}, ${place.country}";
        _locationController.text = "${place.locality}, ${place.country}";
      });
    } catch (e) {
      _locationMessage = "Failed to get city and country";
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
      _isNameEmpty = _nameController.text.isEmpty;
      _isAgeEmpty = _ageController.text.isEmpty || age == null;
      _isBioEmpty = _bioController.text.isEmpty;
      _isLookingForEmpty = _lookingForController.text.isEmpty;
      _isHobbiesEmpty = hobbies.isEmpty;
      _isLocationEmpty = _locationController.text.isEmpty;
    });
    // check if any validation failed
    hasErrors = _isNameEmpty ||
        _isAgeEmpty ||
        _isBioEmpty ||
        _isLookingForEmpty ||
        _isHobbiesEmpty ||
        _isLocationEmpty;
    if (hasErrors) {
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
    await FirebaseFirestore.instance
        .collection('userProfiles')
        .doc(userProfile.userId)
        .set(userProfile.toMap());
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomePage()),
        (Route<dynamic> route) => false);
  }

  // select profile picture
  Future<void> selectImage() async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? file =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        imageUrl = file.path;
      });
      await _uploadImage(File(file.path));
    }
  }

  // upload the selected image
  Future<void> _uploadImage(File imageFile) async {
    String userId = _authService.getCurrentUser()!.uid;
    String fileName = 'userProfiles/$userId/${path.basename(imageFile.path)}';
    Reference storageRef = FirebaseStorage.instance.ref().child(fileName);

    UploadTask uploadTask = storageRef.putFile(imageFile);
    TaskSnapshot snapshot = await uploadTask;
    String imgUrl = await snapshot.ref.getDownloadURL();
    setState(() {
      imageUrl = imgUrl;
    });
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
      body: SingleChildScrollView(
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
                    onPressed: () => selectImage(),
                    icon: const Icon(Icons.add_a_photo),
                  ),
                )
              ],
            ),

            // get name
            SizedBox(height: screenHeight * 0.04),
            MyTextField(
                hintText: 'Name',
                obscureText: false,
                controller: _nameController,
                isError: _isNameEmpty),

            // get age
            SizedBox(height: screenHeight * 0.04),
            MyTextField(
                hintText: 'Age',
                obscureText: false,
                controller: _ageController,
                isError: _isAgeEmpty),

            // location texfield
            SizedBox(height: screenHeight * 0.04),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: GestureDetector(
                onTap: _onLocationFieldTapped,
                child: TextField(
                  enabled: false,
                  controller: _locationController,
                  obscureText: false,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary)
                    ),
                    fillColor: Theme.of(context).colorScheme.secondary,
                    filled: true,
                    hintText: 'Location 2',
                    hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
                    errorText: _isLocationEmpty ? 'This field cannot be empty' : null,
                  ),
                ),
              ),
            ),
            // bio
            SizedBox(height: screenHeight * 0.04),
            MyTextField(
                hintText: 'Tell us a bit about yourself',
                obscureText: false,
                controller: _bioController,
                isError: _isBioEmpty),

            // looking for textfield
            SizedBox(height: screenHeight * 0.04),
            MyTextField(
                hintText: 'What are you looking for',
                obscureText: false,
                controller: _lookingForController,
                isError: _isLookingForEmpty),

            // get hobbies
            SizedBox(height: screenHeight * 0.04),
            MyListField(
                hintText: 'Enter a hobby',
                controller: _hobbyController,
                onSubmitted: _addHobby),
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
            MyButton(text: 'Save Profile', onTap: () => _saveProfile()),
          ],
        ),
      ),
    );
  }
}
