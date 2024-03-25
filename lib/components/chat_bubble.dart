import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../themes/theme_provider.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final String senderName;
  final bool isCurrentUser;

  const ChatBubble(
      {super.key,
      required this.message,
      required this.isCurrentUser,
      required this.senderName});

  @override
  Widget build(BuildContext context) {
    // light vs dark mode for correct bubble colors
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    CrossAxisAlignment bubbleAlignment =
        isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    return Column(
      crossAxisAlignment: bubbleAlignment,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isCurrentUser ? Colors.green : Colors.grey.shade500,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 15),
          child: Text(message, style: const TextStyle(color: Colors.white)),
        ),
        if (!isCurrentUser) // Optionally, show the sender's name for received messages
          Padding(
            padding: const EdgeInsets.only(top: 2, left: 20, right: 20),
            child: Text(senderName.split(' ')[0],
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
          ),
      ],
    );
  }
}
