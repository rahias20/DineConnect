import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_connect/models/message.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Message Model Tests', () {
    test('Message constructor assigns values correctly', () {
      final timestamp = Timestamp.now();
      final message = Message(
        senderId: 'user123',
        senderName: 'John Doe',
        eventId: 'event456',
        message: 'Hello World!',
        timestamp: timestamp,
      );

      expect(message.senderId, 'user123');
      expect(message.senderName, 'John Doe');
      expect(message.eventId, 'event456');
      expect(message.message, 'Hello World!');
      expect(message.timestamp, timestamp);
    });
  });
}
