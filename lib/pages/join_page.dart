import 'package:flutter/material.dart';
import 'package:dine_connect/models/event.dart';
import 'package:intl/intl.dart';

import '../services/authentication/auth_service.dart';
import '../services/eventService.dart';

class JoinPage extends StatefulWidget {
  const JoinPage({super.key});

  @override
  State<JoinPage> createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {
  late EventService _eventService;
  late AuthService _authService;
  late String? currentUserUid;
  List<Event> _joinedUpcomingEvents = [];
  List<Event> _joinedPastEvents = [];

  @override
  void initState() {
    super.initState();
    _eventService = EventService();
    _authService = AuthService();
    _fetchJoinedEvents();
  }
    Future<void> _fetchJoinedEvents() async {
    currentUserUid = _authService.getCurrentUser()?.uid;
    DateTime now = DateTime.now();
    if (currentUserUid != null) {
      try {
        // Assuming EventService has a method to fetch events a user has joined
        List<Event> events = await _eventService.fetchJoinedEventsByUser(currentUserUid!);
        setState(() {
          _joinedUpcomingEvents = events.where((event) => event.eventDate.isAfter(now)).toList();
          _joinedPastEvents = events.where((event) => event.eventDate.isBefore(now)).toList();
        });
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error fetching joined events: $e")));
      }
    }
  }

@override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Joined Events'),
          backgroundColor: colorScheme.secondary,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Upcoming Joined Events'),
              Tab(text: 'Past Joined Events'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildEventsList(_joinedUpcomingEvents, screenHeight, true),
            _buildEventsList(_joinedPastEvents, screenHeight, false),
          ],
        ),
      ),
    );
  }

Widget _buildEventsList(
      List<Event> events, double screenHeight, bool isUpcoming) {
    return Padding(
      padding: EdgeInsets.only(top: screenHeight * 0.02),
      child: ListView.builder(
        itemCount: events.length,
        itemBuilder: (BuildContext context, int index) {
          Event event = events[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: ListTile(

              title: Text(event.description),
              subtitle: Text(
                "${DateFormat('EEE, MMM d, yyyy').format(event.eventDate)} at ${DateFormat('h:mm a').format(event.eventDate)}",
              ),
              trailing: isUpcoming
                  ? IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        // Confirm dialog before leaving
                        bool confirmDelete = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Leave Event'),
                              content: const Text(
                                  'Are you sure you want to leave this event?'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text('Leave',
                                      style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            );
                          },
                        );

                        if (confirmDelete) {
                          // Perform the leave operation
                          await _eventService.removeParticipant(event.eventId, currentUserUid!);
                          // Refresh the list
                          _fetchJoinedEvents();
                        }
                      },
                    )
                  : null, // no trailing button for past events
            ),
          );
        },
      ),
    );
  }
}
