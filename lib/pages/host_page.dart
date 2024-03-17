import 'package:flutter/material.dart';

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
        _upcomingEvents = events.where((event) => event.eventDate.isAfter(now)).toList();
        _pastEvents = events.where((event) => event.eventDate.isBefore(now)).toList();
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
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
        bottom: const TabBar(tabs: [Tab(text: 'Upcoming Events',), Tab(text: 'Past Events',)]),
        ),

        body: TabBarView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.02), // dynamic space before the list
                  Expanded(child: _buildEventsList(_upcomingEvents, screenHeight)),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.02), // dynamic space before the list
                  Expanded(child: _buildEventsList(_pastEvents, screenHeight)),
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

  Widget _buildEventsList(List<Event> events, double screenHeight) {
    return Padding(
      padding: EdgeInsets.only(top: screenHeight * 0.02),
      child: ListView.builder(
        itemCount: events.length,
        itemBuilder: (BuildContext context, int index) {
          Event event = events[index];
          return Card(
            child: ListTile(
              title: Text(event.description),
              subtitle: Text(event.description),
            ),
          );
        },
      ),
    );
  }
}