import 'package:flutter/material.dart';

// Stateless widget for Help and Support page
class HelpAndSupportPage extends StatelessWidget {
  const HelpAndSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Frequently Asked Questions',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            ExpansionTile(
              title: Text('How do I create an event?'),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                      'To create an event, navigate to the "Host" section from the bottom navigation bar and tap on "+". Fill out the event details and tap "Create" to publish your event.'),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('How can I join an event?'),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                      'You can join an event by navigating to the "Join" section from the bottom navigation bar. Browse through the list of upcoming events and tap on the one you are interested in to see more details and join.'),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('How do I report a user?'),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                      'If you encounter any inappropriate behavior or content from another user, you can report them by visiting their profile page and tapping on the "Report" button. After pressing "Report", you will be asked to provide a brief reason for the report. Our team will review the report as soon as possible and take the necessary actions to ensure DineConnect remains a safe and welcoming community for everyone.'),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('How do I cancel an event I created?'),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                      'To cancel an event, navigate to your event details page and tap on "Edit" followed by "Cancel Event". Confirm your action to cancel the event and notify participants.'),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('How do I change my account settings?'),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                      'You can change your account settings by navigating to the "Settings" section from the bottom navigation bar. From there, select "Account" to modify your account details.'),
                ),
              ],
            ),
            SizedBox(height: 24.0),
            Text(
              'Need more help?',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'If you need further assistance, please reach out to our support team at support@dineconnect.com.',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
