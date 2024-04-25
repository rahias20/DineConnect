import 'package:cloud_firestore/cloud_firestore.dart';

// Defines the structure for a chat message within the application.
class Message {
  // Unique identifier for the sender of the message.
  final String senderId;
  final String senderName;
  final String
      eventId; // Unique identifier of the event to which the message is associated.
  final String message;
  final Timestamp timestamp; // Timestamp indicating when the message was sent.

  // Constructor for initializing a Message object with necessary fields.
  Message(
      {required this.senderId,
      required this.senderName,
      required this.eventId,
      required this.message,
      required this.timestamp});
}
