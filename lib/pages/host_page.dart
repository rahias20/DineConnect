import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/event.dart';
import '../services/authentication/auth_service.dart';
import '../services/eventService.dart';

class HostPage extends StatefulWidget {
  const HostPage({super.key});

  @override
  State<HostPage> createState() => _HostPageState();
}

class _HostPageState extends State<HostPage> {
  late EventService _eventService;
  late AuthService _authService;
  List<Event> _upcomingEvents = [];
  List<Event> _pastEvents = [];

  @override
  void initState() {
    super.initState();
    _eventService = EventService();
    _authService = AuthService();
    _fetchCreatedEvents();
  }

  Future<void> _fetchCreatedEvents() async {
    String? uid = _authService.getCurrentUser()?.uid;
    DateTime now = DateTime.now();
    if (uid != null) {
      try {
        List<Event> events = await _eventService.fetchEventsCreatedByUser(uid);
        setState(() {
          _upcomingEvents =
              events.where((event) => event.eventDate.isAfter(now)).toList();
          _pastEvents =
              events.where((event) => event.eventDate.isBefore(now)).toList();
        });
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
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
          title: const Text('Host an Event'),
          backgroundColor: colorScheme.secondary,
          bottom: const TabBar(tabs: [
            Tab(
              text: 'Upcoming Events',
            ),
            Tab(
              text: 'Past Events',
            )
          ]),
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
              child: Column(
                children: [
                  SizedBox(
                      height:
                          screenHeight * 0.02), // dynamic space before the list
                  Expanded(
                      child: _buildEventsList(
                          _upcomingEvents, screenHeight, true)),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
              child: Column(
                children: [
                  SizedBox(
                      height:
                          screenHeight * 0.02), // dynamic space before the list
                  Expanded(
                      child:
                          _buildEventsList(_pastEvents, screenHeight, false)),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, '/createEvent1'),
          child: const Icon(Icons.add),
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
            child: ListTile(
              title: Text(event.description),
              subtitle: Text(
                "${DateFormat('EEE, MMM d, yyyy').format(event.eventDate)} at ${DateFormat('h:mm a').format(event.eventDate)}",
              ),
              trailing: isUpcoming
                  ? IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        // Confirm dialog before deleting
                        bool confirmDelete = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Delete Event'),
                              content: const Text(
                                  'Are you sure you want to delete this event?'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text('Delete',
                                      style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            );
                          },
                        );

                        if (confirmDelete) {
                          // Perform the delete operation
                          await _eventService.deleteEvent(event.eventId);
                          // Refresh the list
                          _fetchCreatedEvents();
                        }
                      },
                    )
                  : null, // no trailing button for past events
              onTap: () {
                // navigate to event details page
                Navigator.pushNamed(context, '/eventContent', arguments: {
                  'event': event,
                  'navbarButtonText': 'Chat',
                  'navbarButtonPressed': () => Navigator.pushNamed(
                      context, '/chatsPage',
                      arguments: event.eventId),
                  'onHostClicked': () => {}
                });
              },
            ),
          );
        },
      ),
    );
  }
}
