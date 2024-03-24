import 'package:dine_connect/services/authentication/auth_service.dart';
import 'package:dine_connect/services/chat_service.dart';
import 'package:dine_connect/services/user_profile_service.dart';
import 'package:flutter/material.dart';

import '../models/user_profile.dart';

class ChatPage extends StatefulWidget {
  final String eventId;

  const ChatPage({super.key, required this.eventId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final AuthService _authService;
  late final UserProfileService _userProfileService;
  late final ChatService _chatService;
  UserProfile? _userProfile;

  @override
  void initState() {
    super.initState();
    _userProfileService = UserProfileService();
    _authService = AuthService();
    _chatService = ChatService();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    String? uid = _authService.getCurrentUser()?.uid;
    if (uid != null) {
      try {
        UserProfile? profile = await _userProfileService.fetchUserProfile(uid);

        if (profile != null) {
          setState(() {
            _userProfile = profile;
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

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
      ),
      body: _userProfile == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _userProfile!.joinedEventsIds.length,
              itemBuilder: (context, index) {
                final eventId = _userProfile!.joinedEventsIds[index];
                return ListTile(
                  title: Text('Event $eventId'),
                  onTap: () {
                    Navigator.pushNamed(context, '/chatsPage',
                        arguments: eventId);
                  },
                );
              },
            ),
    );
  }
}
