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
  const HomePage({super.key});

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
  bool _isLoading = true; // add a loading state

  @override
  void initState() {
    super.initState();
    _userProfileService = UserProfileService();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    String? uid = _authService.getCurrentUser()?.uid;
    if (uid != null) {
      try {
        UserProfile? profile = await _userProfileService.fetchUserProfile(uid);
        if (profile != null) {
          setState(() {
            userProfile = profile;
            _isLoading = false; // loading done
            _loadUpcomingEvents(uid);
          });
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the new page based on index.
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/joinPage').then((_) => refreshEvents());
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
            await _eventService.fetchEventsInCity(userProfile!.location, uid);
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
        backgroundColor: colorScheme.primary,
        title: const Center(child: Text("DineConnect")),
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, '/chatsPage', arguments: 'jghghghg');
          },
          icon: const Icon(Icons.chat_bubble_outline),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/editProfilePage1').then((_) => _fetchUserProfile());
            },
            child: CircleAvatar(
              backgroundImage: userProfile?.imageUrl != null
                  ? NetworkImage(userProfile!.imageUrl.toString())
                  : const AssetImage('lib/images/profile_icon.png')
                      as ImageProvider,
              backgroundColor: Colors.white60,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            ) // show loading indicator
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Welcome, ${userProfile?.name ?? 'Guest'}!',
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 0),
                Expanded(
                  child: ListView.builder(
                    itemCount: _upcomingEvents.length,
                    itemBuilder: (context, index) {
                      // Using a custom 'EventCard' widget to display each event.
                      return EventCard(
                        event: _upcomingEvents[index],
                        onEventJoined: refreshEvents,
                      );
                    },
                  ),
                ),
              ],
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

class EventCard extends StatefulWidget {
  final Event event;
  final VoidCallback onEventJoined;

  const EventCard({Key? key, required this.event, required this.onEventJoined})
      : super(key: key);

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  late UserProfileService _userProfileService;

  @override
  void initState() {
    super.initState();
    _userProfileService = UserProfileService();
  }

  Future<UserProfile> _fetchUserProfile(String uid) async {
    try {
      UserProfile? profile = await _userProfileService.fetchUserProfile(uid);
      if (profile != null) {
        return profile;
      } else {
        throw Exception("Profile not found");
      }
    } catch (e) {
      throw Exception("Failed to fetch profile: $e");
    }
  }

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
          },
        ),
      ).then((_) => {Navigator.pop(context), widget.onEventJoined()});
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

  Future<void> onHostProfileClicked(
      BuildContext context, String hostUserId, String eventId) async {
    UserProfile hostProfile = await _fetchUserProfile(hostUserId);
    Navigator.pushNamed(context, '/hostProfilePage',
        arguments: {'userProfile': hostProfile, 'eventId': eventId});
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat('EEEE d, MMMM, yyyy').format(widget.event.eventDate);
    final formattedTime = DateFormat('h:mm a').format(widget.event.eventDate);
    return Card(
      child: ListTile(
        leading: const Icon(Icons.event),
        title: Text(widget.event.description),
        subtitle:
            Text('${widget.event.city}\n $formattedDate \n $formattedTime'),
        isThreeLine: true,
        onTap: () {
          // Navigate to event details page
          Navigator.pushNamed(context, '/eventContent', arguments: {
            'event': widget.event,
            'navbarButtonText': 'Join',
            'navbarButtonPressed': () => _joinEvent(
                  context,
                  widget.event,
                ),
            'onHostClicked': () => {
                  _fetchUserProfile(widget.event.hostUserId),
                  onHostProfileClicked(
                      context, widget.event.hostUserId, widget.event.eventId)
                }
          });
        },
      ),
    );
  }
}
