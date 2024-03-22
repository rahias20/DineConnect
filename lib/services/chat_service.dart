import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // method to send a message within an event's chatroom
  Future<void> sendMessage(String eventId, String messageText) async {
    final Timestamp timestamp = Timestamp.now();

    // constructing the message object with necessary fields
    Map<String, dynamic> message = {
      'eventId': eventId,
      'message': messageText,
      'timestamp': timestamp,
    };

    // adding the message to the chats collection with event ID as a reference
    await _firestore.collection('chats').add(message);
  }

  // method to fetch messages for an event's chatroom
  Stream<QuerySnapshot> getEventMessages(String eventId) {
    return _firestore
        .collection('chats')
        .where('eventId', isEqualTo: eventId)
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
