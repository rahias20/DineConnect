import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_connect/controller/authentication/auth_service.dart';
import 'package:dine_connect/controller/chat_service.dart';
import 'package:dine_connect/controller/user_profile_service.dart';
import 'package:dine_connect/models/user_profile.dart';
import 'package:flutter/material.dart';

import '../components/chat_bubble.dart';

class ChatsPage extends StatefulWidget {
  final String eventId;
  const ChatsPage({super.key, required this.eventId});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  late final AuthService _authService;
  late final UserProfileService _userProfileService;
  late final UserProfile _userProfile;

  @override
  void initState() {
    super.initState();
    _userProfileService = UserProfileService();
    _authService = AuthService();
    _fetchUserProfile();
  }

  // Fetches user profile to be used in chat messages.
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

  // Function to handle sending messages
  void sendMessage(String eventId) async {
    // if there is something inside the textfield
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(eventId, _userProfile.userId,
          _userProfile.name, _messageController.text);

      // clear text controller
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: Column(
        children: [
          // display all messages
          Expanded(
            child: _buildMessageList(),
          ),
          // user input
          _buildUserInput(),
        ],
      ),
    );
  }

  // Builds a list view of messages using a StreamBuilder
  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
        stream: _chatService.getEventMessages(widget.eventId),
        builder: (context, snapshot) {
          // errors
          if (snapshot.hasError) return const Text("Error");

          // loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading...");
          }

          // return list view
          return ListView(
            children: snapshot.data!.docs
                .map((doc) => _buildMessageItem(doc))
                .toList(),
          );
        });
  }

  // Constructs a chat bubble for each message.
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // is current user
    bool isCurrentUser = data['senderId'] == _authService.getCurrentUser()!.uid;

    // align message to the right if sender is the current user, otherwise left
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ChatBubble(
              message: data["message"],
              senderName: data["senderName"],
              isCurrentUser: isCurrentUser),
        ],
      ),
    );
  }

  // Widget for user input in chat.
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0, right: 7),
      child: Row(
        children: [
          // textfield takes most of the space
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                obscureText: false,
                controller: _messageController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    hintText: 'Type a message . . . '),
              ),
            ),
          ),
          // send button
          Container(
            decoration: const BoxDecoration(
                color: Colors.green, shape: BoxShape.circle),
            child: IconButton(
              onPressed: () => sendMessage(widget.eventId),
              icon: const Icon(Icons.arrow_upward, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
