import 'package:dine_connect/models/event.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/user_profile.dart';
import '../services/authentication/auth_service.dart';
import '../services/eventService.dart';
import '../services/user_profile_service.dart';
import 'navbar_button.dart';

class EventContent extends StatefulWidget {
  final Event event;
  final String navbarButtonText;
  final VoidCallback navbarButtonPressed;
  final VoidCallback onHostClicked;
  const EventContent({
    super.key,
    required this.event,
    required this.navbarButtonText,
    required this.navbarButtonPressed,
    required this.onHostClicked,
  });

  @override
  State<EventContent> createState() => _EventContentState();
}

class _EventContentState extends State<EventContent> {
  UserProfile? _userProfile;
  late UserProfileService _userProfileService;
  final AuthService _authService = AuthService();
  final EventService _eventService = EventService();
  String imageUrl = '';
  // list to store participant profiles
  List<UserProfile> _participantsProfiles = [];

  @override
  void initState() {
    super.initState();
    _userProfileService = UserProfileService();
    _fetchUserProfile();
    _fetchParticipantsProfiles();
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

  Future<void> _fetchParticipantsProfiles() async {
    for (var userId in widget.event.participantUserIds) {
      try {
        UserProfile? profile =
            await _userProfileService.fetchUserProfile(userId);
        if (profile != null) {
          setState(() => _participantsProfiles.add(profile));
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
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
      body: _userProfile == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                                  : const AssetImage(
                                          'lib/images/profile_icon.png')
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
                          onTap: widget.onHostClicked,
                          child: Text(
                            '${_userProfile?.name.split(' ')[0]}',
                            style: TextStyle(
                                fontSize: 16.0, color: Colors.red.shade400),
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
                              .event
                              .eventDate), // Use event.date here formatted
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
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Container(
                            height: 50,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _participantsProfiles.length,
                              itemBuilder: (context, index) {
                                UserProfile participant =
                                    _participantsProfiles[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, '/hostProfilePage',
                                        arguments: {
                                          'userProfile': participant,
                                          'eventId': widget.event.eventId
                                        });
                                  },
                                  child: CircleAvatar(
                                    backgroundImage: participant
                                            .imageUrl!.isNotEmpty
                                        ? NetworkImage(
                                            participant.imageUrl.toString())
                                        : const AssetImage(
                                                'lib/images/profile_icon.png')
                                            as ImageProvider,
                                    backgroundColor: Colors.white60,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          'Maximum ${widget.event.numberOfParticipants} people ',
                          style: TextStyle(fontSize: 11.0),
                        ),
                        Text(
                          '${widget.event.numberOfParticipants - (widget.event.participantUserIds.length + 1)} MORE SPOT OPEN',
                          style: TextStyle(
                              fontSize: 11.0, color: Colors.red.shade400),
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
