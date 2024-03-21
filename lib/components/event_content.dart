import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dine_connect/models/event.dart';
import 'package:intl/intl.dart';

import 'navbar_button.dart';
import '../models/user_profile.dart';
import '../services/authentication/auth_service.dart';
import '../services/eventService.dart';
import '../services/user_profile_service.dart';

class EventContent extends StatefulWidget {
  final Event event;
  final String navbarButtonText;
  final VoidCallback navbarButtonPressed;
  final VoidCallback onHostClicked;
  const EventContent({super.key, required this.event, required this.navbarButtonText, required this.navbarButtonPressed, required this.onHostClicked,});

  @override
  State<EventContent> createState() => _EventContentState();
}

class _EventContentState extends State<EventContent> {
  UserProfile? _userProfile;
  late UserProfileService _userProfileService;
  final AuthService _authService = AuthService();
  final EventService _eventService = EventService();
  String imageUrl = '';

  @override
  void initState() {
    super.initState();
    _userProfileService = UserProfileService();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    String? uid = widget.event.hostUserId;
    try {
      UserProfile? profile = await _userProfileService.fetchUserProfile(uid);
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
                            ? FileImage(File(imageUrl))
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
                  GestureDetector(
                    onTap: (){},
                    child: Text(
                      '${_userProfile?.name.split(' ')[0]}',
                      style: TextStyle(fontSize: 16.0, color: Colors.red[300]),
                    ),
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
        onPressed: widget.navbarButtonPressed,
        buttonText: widget.navbarButtonText,
      ),
    );
  }
}
