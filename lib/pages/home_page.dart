import 'package:dine_connect/services/authentication/auth_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final AuthService _authService = AuthService();
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Home Page"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _authService.signUserOut(),
          ),
        ],
      ),
      body: SafeArea(child: Center(child: Text("Hello World!"))),
    );
  }
}
