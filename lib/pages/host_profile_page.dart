import 'package:dine_connect/services/authentication/auth_service.dart';
import 'package:dine_connect/services/eventService.dart';
import 'package:flutter/material.dart';
import '../components/navbar_button.dart';
import '../components/user_profile_content.dart';
import '../models/user_profile.dart';

class HostProfilePage extends StatefulWidget {
  final String eventId;
  final UserProfile userProfile;
  const HostProfilePage(
      {super.key, required this.userProfile, required this.eventId});

  @override
  State<HostProfilePage> createState() => _HostProfilePageState();
}

class _HostProfilePageState extends State<HostProfilePage> {
  final EventService _eventService = EventService();
  bool _isLoading = false;

  Future<void> onChatPressed() async {
    setState(() {
      _isLoading = true; // show a loading indicator if necessary
    });
    final String currentUserId = AuthService().getCurrentUser()?.uid ?? '';
    try {
      final event = await _eventService.fetchEvent(widget.eventId);
      if (event != null && event.participantUserIds.contains(currentUserId)) {
        // push chats page
        Navigator.pushNamed(context, '/chatPage');
      } else {
        // user has not joined the event, show SnackBar
        ScaffoldMessenger.of(context).showSnackBar( SnackBar(
          content: const Text("Please join the event to start chatting"),
          backgroundColor: Colors.red[500],
          duration: const Duration(seconds: 3),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Host Profile"),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
      ),
      body: UserProfileContent(userProfile: widget.userProfile),
      bottomNavigationBar: NavbarButton(
        onPressed: onChatPressed,
        buttonText: 'Chat',
      ),
    );
  }
}
