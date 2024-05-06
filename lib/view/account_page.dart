import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Stateless widget builds the account settings page
class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  // Method to show a dialog for confirming account deletion.
  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Account"),
          content: const Text(
              "Are you sure you want to permanently delete your account? This action cannot be undone."),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
              onPressed: () async {
                // Delete the user's account
                try {
                  await FirebaseAuth.instance.currentUser!.delete();

                  Navigator.of(context).pop(); // Close the dialog
                  // Optionally, redirect the user to the welcome screen
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/welcomePage', (route) => false);
                } catch (e) {
                  Navigator.of(context).pop(); // Close the dialog
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Failed to delete account: $e"),
                    duration: Duration(seconds: 15),
                  ));
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 1,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person_outlined),
            title: const Text('Profile'),
            subtitle: const Text('View and edit your profile'),
            onTap: () {
              // navigate to profile editing page
              Navigator.pushNamed(context, '/editProfilePage1');
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock_outline_rounded),
            title: const Text('Privacy'),
            subtitle: const Text('Manage your privacy settings'),
            onTap: () {
              // navigate to privacy settings page
            },
          ),
          ListTile(
            leading: const Icon(Icons.password_outlined),
            title: const Text('Change Password'),
            subtitle: const Text('Change your account password'),
            onTap: () {
              // navigate to change password page
              Navigator.pushNamed(context, '/changePasswordPage');
            },
          ),
          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: const Text('Change Email'),
            subtitle: Text(FirebaseAuth.instance.currentUser!.email.toString()),
            onTap: () {
              // navigate to change password page
              Navigator.pushNamed(context, '/changeEmailPage');
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline_outlined),
            title: const Text('Delete Account'),
            subtitle: const Text('Permanently delete your account'),
            onTap: () => _showDeleteAccountDialog(context),
          ),
        ],
      ),
    );
  }
}
