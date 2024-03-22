
import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String eventId;
  final String message;
  final Timestamp timestamp;

  Message({
    required this.eventId,
    required this.message,
    required this.timestamp
});

}