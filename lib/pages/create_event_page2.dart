import 'dart:io';
import 'package:dine_connect/pages/event_details_content.dart';
import 'package:flutter/material.dart';
import 'package:dine_connect/models/event.dart';
import 'package:intl/intl.dart';

import '../models/user_profile.dart';
import '../services/authentication/auth_service.dart';
import '../services/user_profile_service.dart';
import 'package:path/path.dart' as path;



class CreateEventPage2 extends StatefulWidget {
  final Event event;
  const CreateEventPage2({super.key, required this.event});

  @override
  State<CreateEventPage2> createState() => _CreateEventPage2State();
}

class _CreateEventPage2State extends State<CreateEventPage2> {
  UserProfile? _userProfile;
  late UserProfileService _userProfileService;
  final AuthService _authService = AuthService();
  String imageUrl = '';

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
      body: Padding(
          padding: EdgeInsets.all(screenWidth / 7),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.event.description,
                    style: TextStyle(
                      fontSize: screenHeight * 0.04,
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
                      Text(
                        'Hosted by ${_userProfile?.name.split(' ')[0]}',
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),

                  SizedBox(height: screenHeight * 0.04),
                  Row(
                    children: [
                      Icon(Icons.event),
                      const SizedBox(width: 12),
                      Text(
                        DateFormat('EEE, MMM d yyyy\nh:mm a').format(widget.event.eventDate), // Use event.date here formatted
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),

                  SizedBox(height: screenHeight * 0.03),
                  Row(
                    children: [
                      const Icon(Icons.location_on_sharp),
                      const SizedBox(width: 12),
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
                      const SizedBox(width: 12),
                      Text(
                        '${widget.event.numberOfParticipants}',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),

                  Spacer(),
                  Center(
                    child: SizedBox(
                      width: screenWidth / 2, // Make the button expand to the width of the screen
                      child: ElevatedButton(
                        onPressed: (){},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.secondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text('Create'),
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.01),
                ],
              ),
        ),

    );
  }
}
