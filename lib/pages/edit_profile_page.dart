import 'package:dine_connect/pages/user_profile_page.dart';
import 'package:flutter/material.dart';


class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  Widget build(BuildContext context) {
    return UserProfilePage();
  }
}
