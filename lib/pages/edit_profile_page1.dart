import 'package:dine_connect/pages/user_profile_content_page.dart';
import 'package:flutter/material.dart';

class EditProfilePage1 extends StatelessWidget {
  const EditProfilePage1({super.key});
  
  void _editProfile(BuildContext context){
    Navigator.pushNamed(context, '/editProfilePage2');
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => _editProfile(context),
              child: const Text("Edit", style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500
              ),),
            ),
          ),
        ],
      ),
      body: UserProfileContentPage(),
    );
  }
}
