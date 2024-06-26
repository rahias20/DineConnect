import 'package:dine_connect/controller/authentication/auth_service.dart';
import 'package:dine_connect/controller/eventService.dart';
import 'package:dine_connect/controller/user_profile_service.dart';
import 'package:dine_connect/models/event.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/user_profile.dart';

// Widget to manage the state of chat interactions for specific events
class ChatPage extends StatefulWidget {
  final String eventId;

  const ChatPage({super.key, required this.eventId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // Service instances for handling authentication, user profiles, and events
  late final AuthService _authService;
  late final UserProfileService _userProfileService;
  late final EventService _eventService;
  UserProfile? _userProfile;
  late List<Event> events;

  @override
  void initState() {
    super.initState();
    _userProfileService = UserProfileService();
    _authService = AuthService();
    _eventService = EventService();
    events = [];
    _fetchUserProfile(); // Start fetching user profile on init
  }

  Future<void> _fetchUserProfile() async {
    String? uid = _authService.getCurrentUser()?.uid;
    if (uid != null) {
      try {
        UserProfile? profile = await _userProfileService.fetchUserProfile(uid);

        if (profile != null) {
          setState(() {
            _userProfile = profile;
            _fetchUserEvents(); // Fetch events after fetching profile.
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

  Future<void> _fetchUserEvents() async {
    List<Event> fetchedEvents = [];
    for (String eventId in _userProfile!.joinedEventsIds) {
      Event? event = await _eventService.fetchEvent(eventId);
      if (event != null) {
        fetchedEvents.add(event);
      }
    }

    // Sorts events by date.
    fetchedEvents.sort((a, b) => a.eventDate.compareTo(b.eventDate));
    if (mounted) {
      setState(() {
        events = fetchedEvents;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final DateTime now = DateTime.now();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
      ),
      body: _userProfile == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                Event event = events[index];
                bool isPastEvent = event.eventDate.isBefore(now);
                return ListTile(
                  title: Text(
                    event.description,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: isPastEvent ? Colors.grey : Colors.black87),
                  ),
                  subtitle: Text(
                    DateFormat('EEE, MMM d yyyy h:mm a')
                        .format(event.eventDate), // formatted event date
                    style: TextStyle(
                      color: isPastEvent ? Colors.grey : Colors.black54,
                    ),
                  ),
                  // Navigate to the event chat page on tap.
                  onTap: () {
                    Navigator.pushNamed(context, '/chatsPage',
                        arguments: events[index].eventId);
                  },
                );
              },
            ),
    );
  }
}
