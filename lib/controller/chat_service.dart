import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Sends a message within an event's chatroom.
  ///
  /// Parameters:
  /// - `eventId`: The ID of the event for which the message is being sent.
  /// - `senderId`: The ID of the user sending the message.
  /// - `senderName`: The name of the user sending the message.
  /// - `messageText`: The content of the message being sent.

  // method to send a message within an event's chatroom
  Future<void> sendMessage(String eventId, String senderId, String senderName,
      String messageText) async {
    final Timestamp timestamp = Timestamp.now();

    // Constructing the message object with necessary fields.
    Map<String, dynamic> message = {
      'senderId': senderId,
      'senderName': senderName,
      'eventId': eventId,
      'message': messageText,
      'timestamp': timestamp,
    };

    // Adding the message to the Firestore database under a
    // specific event's message collection.
    await _firestore
        .collection('chats')
        .doc(eventId)
        .collection('messages')
        .add(message);
  }

  /// Fetches all messages for a specific event's chatroom, ordered by timestamp.
  ///
  /// Parameters:
  /// - `eventId`: The ID of the event whose messages are to be fetched.
  ///
  /// Returns:
  /// - `Stream<QuerySnapshot>`: A stream of Firestore query snapshots
  ///                   that can be listened to for real-time updates.

  Stream<QuerySnapshot> getEventMessages(String eventId) {
    return _firestore
        .collection('chats') // Using a separate 'chats' collection
        .doc(eventId)
        .collection('messages')
        .orderBy('timestamp', descending: false) // Order the chats by timestamp
        .snapshots();
  }
}
