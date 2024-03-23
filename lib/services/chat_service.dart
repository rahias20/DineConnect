import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // method to send a message within an event's chatroom
  Future<void> sendMessage(String eventId, String senderId, String senderName,
      String messageText) async {
    final Timestamp timestamp = Timestamp.now();

    // constructing the message object with necessary fields
    Map<String, dynamic> message = {
      'senderId': senderId,
      'senderName': senderName,
      'eventId': eventId,
      'message': messageText,
      'timestamp': timestamp,
    };

    // adding the message to the chats collection with event ID as a reference
    await _firestore
        .collection('chats')
        .doc(eventId)
        .collection('messages')
        .add(message);
  }

  // method to fetch messages for an event's chatroom
  Stream<QuerySnapshot> getEventMessages(String eventId) {
    return _firestore
        .collection('chats') // Using a separate 'chats' collection
        .doc(eventId)
        .collection('messages')
        .orderBy('timestamp', descending: false) // Order the chats by timestamp
        .snapshots();
  }
}
