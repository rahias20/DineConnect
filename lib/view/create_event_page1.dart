import 'package:dine_connect/controller/user_profile_service.dart';
import 'package:dine_connect/models/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../components/my_text_form_field2.dart';
import '../controller/authentication/auth_service.dart';
import '../models/event.dart';

// Stateful widget for creating an event, takes user input for event details
class CreateEventPage1 extends StatefulWidget {
  const CreateEventPage1({super.key});

  @override
  State<CreateEventPage1> createState() => _CreateEventPage1State();
}

class _CreateEventPage1State extends State<CreateEventPage1> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  String eventId = const Uuid().v4();
  late final UserProfile _userProfile;
  late final UserProfileService _userProfileService;

  // Controllers for text fields
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressLine1Controller = TextEditingController();
  final TextEditingController _addressLine2Controller = TextEditingController();
  final TextEditingController _townCityController = TextEditingController();
  final TextEditingController _postcodeController = TextEditingController();

  late Event newEvent; // Event data model
  int noOfPeople = 2; // Initial no of participants
  DateTime selectedDate = DateTime.now(); // Default event date and time

  @override
  void dispose() {
    _descriptionController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _townCityController.dispose();
    _postcodeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _userProfileService = UserProfileService();
    _fetchUserProfile(); // Fetch user profile at start
  }

  // get formatted date
  String getFormattedDate() {
    return DateFormat('dd-MM-yyyy - h:mm a').format(selectedDate);
  }

  // Display date and time pickers
  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDate),
      );
      if (pickedTime != null) {
        setState(() {
          selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _fetchUserProfile() async {
    String? uid = _authService.getCurrentUser()?.uid;
    if (uid != null) {
      try {
        UserProfile? profile = await _userProfileService.fetchUserProfile(uid);

        if (profile != null) {
          setState(() {
            _userProfile = profile;
          });
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
    return;
  }

  // save event information in event model
  void _saveEvent() {
    // get logged in user's uid
    String uid = _authService.getCurrentUser()!.uid;
    newEvent = Event(
        eventId: eventId,
        hostUserId: uid,
        hostName: _userProfile.name.split('/')[0],
        description: _descriptionController.text,
        eventDate: selectedDate,
        addressLine1: _addressLine1Controller.text,
        addressLine2: _addressLine2Controller.text,
        city: _townCityController.text.trim(),
        postcode: _postcodeController.text,
        numberOfParticipants: noOfPeople,
        participantUserIds: []);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    // use MediaQuery to get the screen size for responsive padding
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.09,
              vertical: screenHeight * 0.03,
            ),
            child: Column(
              children: [
                Text(
                  "Let's get your event registered",
                  style: TextStyle(fontSize: screenHeight * 0.04),
                ),

                SizedBox(height: screenHeight * 0.04),
                MyTextFormField2(
                  controller: _descriptionController,
                  labelText: 'Description',
                  prefixIcon: Icons.description_outlined,
                  maxLines: 2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    } else if (value.length > 70) {
                      return 'Description too long';
                    }
                    return null;
                  },
                ),

                // date and time
                SizedBox(height: screenHeight * 0.002),
                ListTile(
                  title: Text(
                    getFormattedDate(),
                    style: const TextStyle(fontSize: 17),
                  ),
                  leading: const Icon(Icons.date_range_rounded),
                  onTap: () => _selectDateTime(context),
                ),

                // no of people
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(Icons.person),
                      SizedBox(width: screenWidth * 0.01),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (noOfPeople > 2) noOfPeople--;
                          });
                        },
                      ),
                      Text(
                        '$noOfPeople',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            noOfPeople++;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                // address line 1
                SizedBox(height: screenHeight * 0.004),
                TextFormField(
                  controller: _addressLine1Controller,
                  decoration: const InputDecoration(
                    labelText: 'Address line 1',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '';
                    }
                    return null;
                  },
                ),

                // address line 2
                TextFormField(
                  controller: _addressLine2Controller,
                  decoration: const InputDecoration(
                    labelText: 'Address line 2',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '';
                    }
                    return null;
                  },
                ),

                // town/city
                TextFormField(
                  controller: _townCityController,
                  decoration: InputDecoration(
                    labelText: 'Town/City',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '';
                    }
                    return null;
                  },
                ),

                // postcode
                TextFormField(
                  controller: _postcodeController,
                  decoration: const InputDecoration(
                    labelText: 'Postcode',
                  ),
                  validator: (value) {
                    String pattern =
                        r'^[A-Z]{1,2}[0-9R][0-9A-Z]? ?[0-9][ABD-HJLNP-UW-Z]{2}$';
                    RegExp regExp = RegExp(pattern, caseSensitive: false);
                    if (value == null || value.isEmpty) {
                      return '';
                    } else if (!regExp.hasMatch(value)) {
                      return 'Invalid Postcode';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),

      // button for navigating to review event details and create event
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
            bottom: screenHeight *
                0.02), // this ensures the button is visible above any system UI at the bottom of the screen.
        child: FloatingActionButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _saveEvent();
              Navigator.pushNamed(context, '/createEvent2',
                  arguments: newEvent);
            }
          },
          child: const Icon(Icons.arrow_forward),
        ),
      ),
    );
  }
}
