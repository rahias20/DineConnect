import 'package:dine_connect/pages/event_details_content.dart';
import 'package:flutter/material.dart';
import 'package:dine_connect/models/event.dart';

class CreateEventPage2 extends StatelessWidget {
  final Event event;
  const CreateEventPage2({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    // use MediaQuery to get the screen size for responsive padding
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.description,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: screenHeight * 0.04),
            Text(
              'Hosted by ${event.hostUserId}',
              style: const TextStyle(fontSize: 16.0),
            ),

            SizedBox(height: screenHeight * 0.04),
            Text(
              event.eventDate as String, // Use event.date here formatted
              style: const TextStyle(fontSize: 16.0),
            ),


            Text(
              '${event.addressLine1}\n${event.addressLine2}\n${event.city}\n${event.postcode}', // Use event.location here
              style: TextStyle(fontSize: 16.0),
            ),

            SizedBox(height: screenHeight * 0.04),
            Text(
              '${event.participantUserIds.length}',
              style: TextStyle(fontSize: 16.0),
            ),

            Spacer(),
            Center(
              child: SizedBox(
                width: screenWidth / 3, // Make the button expand to the width of the screen
                child: ElevatedButton(
                  onPressed: (){},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text('Create'),
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.01),
          ],
        ),
      ),
    );
  }
}
