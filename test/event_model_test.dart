import 'package:dine_connect/models/event.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Event Model Tests', () {
    test('Event.toMap() should convert event to map correctly', () {
      final event = Event(
        eventId: '1',
        hostUserId: 'user1',
        hostName: 'John Doe',
        description: 'Fun event',
        eventDate: DateTime.parse('2024-03-24T18:00:00Z'),
        addressLine1: '123 Street',
        addressLine2: 'Apt 4',
        city: 'Anytown',
        postcode: '12345',
        numberOfParticipants: 10,
        participantUserIds: ['user2', 'user3'],
      );

      final eventMap = event.toMap();

      expect(eventMap['eventId'], event.eventId);
      expect(eventMap['ownerUserId'], event.hostUserId);
      expect(eventMap['hostName'], event.hostName);
      expect(eventMap['description'], event.description);
      expect(eventMap['eventDate'], event.eventDate.toIso8601String());
      expect(eventMap['addressLine1'], event.addressLine1);
      expect(eventMap['addressLine2'], event.addressLine2);
      expect(eventMap['city'], event.city);
      expect(eventMap['postcode'], event.postcode);
      expect(eventMap['numberOfParticipants'], event.numberOfParticipants);
      expect(List<String>.from(eventMap['participantUserIds']),
          event.participantUserIds);
    });

    test('Event.fromMap() should convert map to event correctly', () {
      final eventMap = {
        'eventId': '1',
        'ownerUserId': 'user1',
        'hostName': 'John Doe',
        'description': 'Fun event',
        'eventDate': '2024-03-24T18:00:00Z',
        'addressLine1': '123 Street',
        'addressLine2': 'Apt 4',
        'city': 'Anytown',
        'postcode': '12345',
        'numberOfParticipants': 10,
        'participantUserIds': ['user2', 'user3'],
      };

      final event = Event.fromMap(eventMap);

      expect(event.eventId, eventMap['eventId']);
      expect(event.hostUserId, eventMap['ownerUserId']);
      expect(event.hostName, eventMap['hostName']);
      expect(event.description, eventMap['description']);
      expect(event.addressLine1, eventMap['addressLine1']);
      expect(event.addressLine2, eventMap['addressLine2']);
      expect(event.city, eventMap['city']);
      expect(event.postcode, eventMap['postcode']);
      expect(event.numberOfParticipants, eventMap['numberOfParticipants']);
    });
  });
}
