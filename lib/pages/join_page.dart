import 'package:flutter/material.dart';

class JoinPage extends StatelessWidget {
  const JoinPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
      ),
      body: Center(child: Text('Join Page')),
    );
  }
}