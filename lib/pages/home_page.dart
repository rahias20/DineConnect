import 'package:dine_connect/models/event.dart';
import 'package:dine_connect/pages/complete_profile_page.dart';
import 'package:dine_connect/services/authentication/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../components/event_dialog.dart';
import '../models/user_profile.dart';
import '../services/eventService.dart';
import '../services/user_profile_service.dart';

// Home page widget, displays upcoming events
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
        bool? isProfileComplete = profile?.name.isNotEmpty;
        if (profile == null || !isProfileComplete!) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const CompleteProfilePage(),
            ));
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

  // Method to get upcoming events in the user's city
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
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } else {
      setState(() {
        _isLoading = false; // loading done
      });
    }
  }

  // Refresh events list on home page
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
        title: Center(
          child: Text(
            "DineConnect",
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                shadows: [
                  Shadow(
                      blurRadius: 10.0,
                      color: Colors.black.withOpacity(0.4),
                      offset: const Offset(2.0, 2.0))
                ]),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, '/chatPage', arguments: 'jghghghg');
          },
          icon: const Icon(Icons.chat_bubble_outline),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/editProfilePage1')
                  .then((_) => _fetchUserProfile());
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
          ? const Center(
              child: CircularProgressIndicator(),
            ) // show loading indicator
          : _upcomingEvents.isEmpty
              ? const Center(
                  child: Text(
                    'No events in your city at the moment. Check back later!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18.0,
                    ),
                  ),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 16.0, left: 16.0, top: 5.0),
                      child: Text(
                        'Welcome, ${userProfile?.name ?? 'Guest'}!',
                        style: const TextStyle(
                            fontSize: 24.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 2.0),
                      child: Text(
                        'Discover nearby events for delightful dining experiences',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          // Choose a color that fits your app theme
                          fontSize: 18.0, // Adjust the size as per your design
                          fontStyle: FontStyle
                              .italic, // You can also make it italic if you want
                          shadows: [
                            Shadow(
                              blurRadius: 2.0,
                              color: Colors.grey.withOpacity(0.5),
                              offset: const Offset(1.0, 1.0),
                            ),
                          ], // Optional: text shadow
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
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

//
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
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final ThemeData themeData = Theme.of(context);

    final formattedDate =
        DateFormat('EEE, d MMMM').format(widget.event.eventDate);
    final formattedTime = DateFormat('h:mm a').format(widget.event.eventDate);
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
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
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.event.description,
                style: themeData.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Hosted by ${widget.event.hostName}',
                style: themeData.textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(widget.event.city,
                      style: themeData.textTheme.bodyMedium),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text('$formattedDate at $formattedTime',
                      style: themeData.textTheme.bodyMedium),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
