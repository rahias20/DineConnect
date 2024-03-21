import 'package:flutter/material.dart';
import '../components/navbar_button.dart';
import '../components/user_profile_content.dart';
import '../models/event.dart';
import '../models/user_profile.dart';


class HostProfilePage extends StatefulWidget {
  final String eventId;
  final UserProfile userProfile;
  const HostProfilePage({super.key, required this.userProfile, required this.eventId});

  @override
  State<HostProfilePage> createState() => _HostProfilePageState();
}

class _HostProfilePageState extends State<HostProfilePage> {
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
        onPressed: (){},
        buttonText: 'Chat',
      ),
    );
  }
}
