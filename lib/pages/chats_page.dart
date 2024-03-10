import 'package:flutter/material.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
      ),
      body: Center(
        child: Text('C h a t s P a g e'),
      ),
    );
  }
}
