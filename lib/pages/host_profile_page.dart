import 'package:dine_connect/services/authentication/auth_service.dart';
import 'package:dine_connect/services/eventService.dart';
import 'package:dine_connect/services/user_profile_service.dart';
import 'package:flutter/material.dart';

import '../components/navbar_button.dart';
import '../components/user_profile_content.dart';
import '../models/user_profile.dart';

// Widget to display the profile of the event host
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
  final UserProfileService _userProfileService = UserProfileService();
  bool _isLoading = false;

  // Function to handle user report action
  Future<void> onReportPressed() async {
    setState(() {
      _isLoading = true; // show a loading indicator if necessary
    });
    final String currentUserId = AuthService().getCurrentUser()?.uid ?? '';
    try {
      final event = await _eventService.fetchEvent(widget.eventId);
      if (event != null && event.participantUserIds.contains(currentUserId)) {
        final TextEditingController reasonController = TextEditingController();
        final AuthService _authService = AuthService();

        if (!mounted) return;
        // Display an alert dialog for the user to input their report reason
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Report User'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: [
                      Text(
                          'Please enter the reason for reporting ${widget.userProfile.name}:'),
                      TextField(
                        decoration: const InputDecoration(
                          hintText: "Reason for reporting",
                        ),
                        maxLines: 5,
                        minLines: 1,
                        controller: reasonController,
                      )
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel')),
                  TextButton(
                      onPressed: () async {
                        String? reportingUserId =
                            _authService.getCurrentUser()?.uid.toString();
                        // logic to handle the  report submission call your service to send the report to backend
                        await _userProfileService.reportUser(
                            reportingUserId!,
                            widget.userProfile.userId,
                            reasonController.text.trim());
                        Navigator.of(context).pop();

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text(
                              "User Reported. We will take appropriate action."),
                          backgroundColor: Colors.green[500],
                          duration: const Duration(seconds: 3),
                        ));
                      },
                      child: const Text('Report'))
                ],
              );
            });
      } else {
        // user has not joined the event, show SnackBar
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("Event not joined!"),
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
        onPressed: onReportPressed,
        buttonText: 'Report',
      ),
    );
  }
}
