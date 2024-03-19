import 'package:flutter/material.dart';

class EventDialog extends StatelessWidget {
  final String titleText;
  final String dialogText;
  final void Function() onDialogClose;
  final int durationInSeconds;

  const EventDialog(
      {super.key,
      required this.onDialogClose,
      required this.dialogText,
      required this.durationInSeconds,
      required this.titleText});

  @override
  Widget build(BuildContext context) {
    // Show dialog upon widget build
    Future.microtask(() => _showEventCreatedDialog(context));

    // Placeholder widget, actual dialog is shown through showDialog
    return Container();
  }

  void _showEventCreatedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titleText),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Icon(Icons.check_circle, color: Colors.green, size: 70),
                Text(dialogText), // Dialog text is used here
              ],
            ),
          ),
        );
      },
    );

    // Delayed navigation
    Future.delayed(Duration(seconds: durationInSeconds), () {
      Navigator.of(context).pop(); // Close the dialog
      onDialogClose(); // Call the provided closure function
    });
  }
}