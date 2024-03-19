import 'dart:io';
import 'package:dine_connect/services/authentication/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../components/event_dialog.dart';
import '../models/user_profile.dart';
import '../services/eventService.dart';
import '../services/user_profile_service.dart';
import 'package:dine_connect/models/event.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();
  UserProfile? userProfile;
  late UserProfileService _userProfileService;
  final EventService _eventService = EventService();
  List<Event> _upcomingEvents = [];
  int _selectedIndex = 0;

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
          userProfile = profile;
          _loadUpcomingEvents(uid);
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the new page based on index.
    switch (index) {
      case 0:
        // Navigator.pushNamed(context, '/joinPage');
        break;
      case 1:
        Navigator.pushNamed(context, '/hostPage');
        break;
      case 2:
        Navigator.pushNamed(context, '/settingsPage');
        break;
    }
  }

  Future<void> _loadUpcomingEvents(String uid) async {
    String? uid = _authService.getCurrentUser()?.uid;
    DateTime now = DateTime.now();
    if (uid != null) {
      try {
        List<Event> events =
            await _eventService.fetchEventsInCity('Aberdeen', uid);
        setState(() {
          _upcomingEvents =
              events.where((event) => event.eventDate.isAfter(now)).toList();
        });
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  void refreshEvents() async {
    await _loadUpcomingEvents(_authService.getCurrentUser()?.uid ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Center(child: Text("DineConnect")),
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, '/chatsPage');
          },
          icon: const Icon(Icons.chat_bubble_outline),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/editProfilePage1');
            },
            child: CircleAvatar(
              backgroundImage: userProfile?.imageUrl != null
                  ? FileImage(File(userProfile!.imageUrl.toString()))
                  : const AssetImage('lib/images/profile_icon.png')
                      as ImageProvider,
              backgroundColor: Colors.white60,
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _upcomingEvents.length,
        itemBuilder: (context, index) {
          // Using a custom 'EventCard' widget to display each event.
          return EventCard(
              event: _upcomingEvents[index], onEventJoined: refreshEvents);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Join',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_sharp),
            label: 'Host',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: colorScheme.primary,
        onTap: _onItemTapped,
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback onEventJoined;

  const EventCard({Key? key, required this.event, required this.onEventJoined})
      : super(key: key);

  void _joinEvent(BuildContext context, Event event) async {
    final EventService _eventService = EventService();
    final AuthService _authService = AuthService();

    try {
      final String userId = _authService.getCurrentUser()?.uid ?? '';
      await _eventService.addParticipant(event.eventId, userId);
      // Show a success message
      showDialog(
        context: context,
        builder: (_) => EventDialog(
          titleText: "Event Joined",
          dialogText: "",
          durationInSeconds: 1,
          onDialogClose: () {
            // specify what happens after the dialog is closed
            Navigator.pop(context); // close the dialog if needed
            Navigator.pop(context);
          },
        ),
      );
      onEventJoined();
    } catch (e) {
      // Handle errors, e.g., show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to join the event: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat('EEEE d, MMMM, yyyy').format(event.eventDate);
    final formattedTime = DateFormat('h:mm a').format(event.eventDate);
    return Card(
      child: ListTile(
        leading: const Icon(Icons.event),
        title: Text(event.description),
        subtitle: Text('${event.city}\n $formattedDate \n $formattedTime'),
        isThreeLine: true,
        onTap: () {
          // Navigate to event details page
          Navigator.pushNamed(context, '/eventContent', arguments: {
            'event': event,
            'navbarButtonText': 'Join',
            'navbarButtonPressed': () => _joinEvent(context, event),
          });
        },
      ),
    );
  }
}
