import 'package:dine_connect/components/my_textfield.dart';
import 'package:dine_connect/services/chat_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatsPage extends StatefulWidget {
  final String eventId;
  const ChatsPage({super.key, required this.eventId});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();

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
        Expanded(child: _buildMessageList(),
        ),
        // user input
        _buildUserInput(),

      ],
      ),
    );
  }
  Widget _buildMessageList(){
    return const Center(
      child: Text('Chats'),
    );
  }

  // message input build widget
  Widget _buildUserInput() {
    return Row(
      children: [
        // message textfield takes most of the space
        Expanded(
          child: MyTextField(
            hintText: 'Type a message . . . ',
            obscureText: false,
            controller: _messageController,
          ),
        ),

        // send button
        IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.arrow_upward,
              color: Colors.white,
            ))
      ],
    );
  }
}
