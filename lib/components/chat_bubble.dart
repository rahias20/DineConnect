import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../themes/theme_provider.dart';

class ChatBubble extends StatelessWidget {
  final String message; // message to display inside the bubble
  final String senderName; // the name of the sender of the message
  final bool isCurrentUser; // to determine if current user sent the messaage

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

    // aligning the bubble on the right if the current user is the sender, otherwise on the left.
    CrossAxisAlignment bubbleAlignment =
        isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    return Column(
      crossAxisAlignment: bubbleAlignment,
      children: [
        // Container for the chat bubble that visually represents the message.
        Container(
          decoration: BoxDecoration(
            // Changing color based on whether the message is sent or received.
            color: isCurrentUser ? Colors.green : Colors.grey.shade500,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 15),
          // Displaying the message text inside the bubble.
          child: Text(message, style: const TextStyle(color: Colors.white)),
        ),
        // Conditionally display the sender's name below the message if not sent by the current user.
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
