import 'dart:io';
import 'package:dine_connect/models/user_profile.dart';
import 'package:flutter/material.dart';

class UserProfileContent extends StatefulWidget {
  final UserProfile userProfile;
  const UserProfileContent({super.key, required this.userProfile});

  @override
  State<UserProfileContent> createState() => _UserProfileContentState();
}

class _UserProfileContentState extends State<UserProfileContent> {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: widget.userProfile == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.04),
                    CircleAvatar(
                      radius: screenHeight * 0.125,
                      backgroundImage: widget.userProfile!.imageUrl!.isNotEmpty
                          ? FileImage(File(widget.userProfile!.imageUrl.toString()))
                          : const AssetImage('lib/images/profile_icon.png')
                              as ImageProvider,
                      backgroundColor: Colors.white60,
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Text(
                      "${widget.userProfile!.name}, ${widget.userProfile!.age}",
                      style: TextStyle(
                        fontSize: screenHeight * 0.029, // Dynamic font size
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.005),
                    Text(
                      widget.userProfile!.location,
                      style: TextStyle(
                        fontSize: screenHeight * 0.025, // Dynamic font size
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    _infoCard(
                        "Bio", widget.userProfile!.bio, screenHeight, screenWidth),
                    _infoCard("Looking For", widget.userProfile!.lookingFor,
                        screenHeight, screenWidth),
                    _hobbiesWrap(
                        widget.userProfile!.hobbies, screenHeight, screenWidth),
                    SizedBox(height: screenHeight * 0.05),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _infoCard(
      String title, String content, double screenHeight, double screenWidth) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05, vertical: screenHeight * 0.01),
      child: Padding(
        padding: EdgeInsets.all(screenHeight * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: screenHeight * 0.022,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              content,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: screenHeight * 0.02),
            ),
          ],
        ),
      ),
    );
  }

  Widget _hobbiesWrap(
      List<String> hobbies, double screenHeight, double screenWidth) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.05),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 4.0,
        children: hobbies
            .map((hobby) => Chip(
                  label: Text(hobby),
                  backgroundColor: colorScheme.secondary,
                ))
            .toList(),
      ),
    );
  }
}
