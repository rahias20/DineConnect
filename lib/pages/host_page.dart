import 'package:flutter/material.dart';

class HostPage extends StatefulWidget {
  const HostPage({super.key});

  @override
  State<HostPage> createState() => _HostPageState();
}

class _HostPageState extends State<HostPage> {
  final List<String> _upcomingEvents = ['Event A', 'Event B', 'Event C','Event A', 'Event B', 'Event C','Event D', 'Event E', 'Event F'];
  final List<String> _pastEvents = ['Event D', 'Event E', 'Event F','Event D', 'Event E', 'Event F','Event D', 'Event E', 'Event F'];

  void _navigateToCreateEvent(BuildContext context) {
    // Navigate to the Create Event page
    Navigator.pushNamed(context, '/createEvent1');
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
                  Expanded(child: _buildEventsList(_upcomingEvents)),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.02), // dynamic space before the list
                  Expanded(child: _buildEventsList(_pastEvents)),
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

  Widget _buildEventsList(List<String> events) {
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: ListTile(
            title: Text(events[index]),
            // You can add onTap to navigate to the event detail
          ),
        );
      },
    );
  }
}