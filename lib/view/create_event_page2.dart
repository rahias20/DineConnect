import 'package:dine_connect/components/navbar_button.dart';
import 'package:dine_connect/controller/eventService.dart';
import 'package:dine_connect/models/event.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../controller/authentication/auth_service.dart';
import '../controller/user_profile_service.dart';
import '../models/user_profile.dart';

// Widget displays event details entered by user to view and create or edit the details
class CreateEventPage2 extends StatefulWidget {
  final Event event; // Event object passed to this page

  const CreateEventPage2({super.key, required this.event});

  @override
  State<CreateEventPage2> createState() => _CreateEventPage2State();
}

class _CreateEventPage2State extends State<CreateEventPage2> {
  UserProfile? _userProfile;
  late UserProfileService _userProfileService;
  final AuthService _authService = AuthService();
  final EventService _eventService = EventService();
  String imageUrl = ''; // URL for the user's profile image

  @override
  void initState() {
    super.initState();
    _userProfileService = UserProfileService();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    String? uid = _authService.getCurrentUser()?.uid;
    try {
      UserProfile? profile = await _userProfileService.fetchUserProfile(uid!);
      if (profile != null) {
        setState(() {
          _userProfile = profile;
          imageUrl = _userProfile?.imageUrl ?? '';
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  // Handles the event creation logic
  Future<void> _createEvent() async {
    try {
      await _eventService.saveEvent(widget.event);
      // if the event saved is successful show 'Event Created
      _showEventCreatedDialogAndNavigate();
    } catch (e) {
      final snackBar =
          SnackBar(content: Text('Failed to create event: ${e.toString()}'));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  // Displays a dialog upon the creation of an event and navigates back to the homepage
  void _showEventCreatedDialogAndNavigate() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('Event Created'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Icon(Icons.check_circle, color: Colors.green, size: 70),
              ],
            ),
          ),
        );
      },
    );

    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pop();
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/homepage',
        (Route<dynamic> route) => false,
      );
    });
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth / 7),
          child: Column(
            children: [
              Text(
                widget.event.description,
                style: TextStyle(
                  fontSize: screenHeight * 0.03,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: screenHeight * 0.04),
              Row(
                children: [
                  SizedBox(height: screenHeight * 0.04),
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: screenWidth * 0.05,
                        backgroundImage: imageUrl.isNotEmpty
                            ? NetworkImage(imageUrl)
                            : const AssetImage('lib/images/profile_icon.png')
                                as ImageProvider,
                        backgroundColor: Colors.white60,
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Hosted by ',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Text(
                    '${_userProfile?.name.split(' ')[0]}',
                    style: TextStyle(fontSize: 16.0, color: Colors.red[300]),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.04),
              Row(
                children: [
                  const Icon(Icons.event),
                  const SizedBox(width: 15),
                  Text(
                    DateFormat('EEE, MMM d yyyy\nh:mm a').format(widget
                        .event.eventDate), // Use event.date here formatted
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.03),
              Row(
                children: [
                  const Icon(Icons.location_on_sharp),
                  const SizedBox(width: 15),
                  Text(
                    '${widget.event.addressLine1}\n${widget.event.addressLine2}\n${widget.event.city}\n${widget.event.postcode}', // Use event.location here
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.04),
              Row(
                children: [
                  const Icon(Icons.person),
                  const SizedBox(width: 15),
                  Text(
                    '${widget.event.numberOfParticipants}',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavbarButton(
        onPressed: _createEvent,
        buttonText: 'Create',
      ),
    );
  }
}
