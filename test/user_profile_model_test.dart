import 'package:dine_connect/models/user_profile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserProfile Model Tests', () {
    // test data
    final Map<String, dynamic> userProfileData = {
      'userId': 'user123',
      'name': 'John Doe',
      'userEmail': 'john.doe@example.com',
      'age': 30,
      'bio': 'Love to travel and eat',
      'lookingFor': 'Friendship and fun',
      'imageUrl': 'http://example.com/image.jpg',
      'location': 'New York',
      'hobbies': ['Reading', 'Swimming'],
      'joinedEventsIds': ['event1', 'event2'],
    };

    test('UserProfile Constructor Test', () {
      final UserProfile userProfile = UserProfile(
        userId: 'user123',
        name: 'John Doe',
        userEmail: 'john.doe@example.com',
        age: 30,
        bio: 'Love to travel and eat',
        lookingFor: 'Friendship and fun',
        imageUrl: 'http://example.com/image.jpg',
        location: 'New York',
        hobbies: ['Reading', 'Swimming'],
        joinedEventsIds: ['event1', 'event2'],
      );

      expect(userProfile.userId, 'user123');
      expect(userProfile.name, 'John Doe');
      expect(userProfile.userEmail, 'john.doe@example.com');
      expect(userProfile.age, 30);
      expect(userProfile.bio, 'Love to travel and eat');
      expect(userProfile.lookingFor, 'Friendship and fun');
      expect(userProfile.imageUrl, 'http://example.com/image.jpg');
      expect(userProfile.location, 'New York');
      expect(userProfile.hobbies, contains('Reading'));
      expect(userProfile.hobbies, contains('Swimming'));
      expect(userProfile.joinedEventsIds, contains('event1'));
      expect(userProfile.joinedEventsIds, contains('event2'));
    });

    test('UserProfile toMap Test', () {
      final UserProfile userProfile = UserProfile.fromMap(userProfileData);
      final Map<String, dynamic> map = userProfile.toMap();

      expect(map['userId'], 'user123');
      expect(map['name'], 'John Doe');
      expect(map['userEmail'], 'john.doe@example.com');
      expect(map['age'], 30);
      expect(map['bio'], 'Love to travel and eat');
      expect(map['lookingFor'], 'Friendship and fun');
      expect(map['imageUrl'], 'http://example.com/image.jpg');
      expect(map['location'], 'New York');
      expect(map['hobbies'], contains('Reading'));
      expect(map['hobbies'], contains('Swimming'));
      expect(map['joinedEventsIds'], contains('event1'));
      expect(map['joinedEventsIds'], contains('event2'));
    });

    test('UserProfile fromMap Test', () {
      final UserProfile userProfileFromMap =
          UserProfile.fromMap(userProfileData);

      expect(userProfileFromMap.userId, 'user123');
      expect(userProfileFromMap.name, 'John Doe');
      expect(userProfileFromMap.userEmail, 'john.doe@example.com');
      expect(userProfileFromMap.age, 30);
      expect(userProfileFromMap.bio, 'Love to travel and eat');
      expect(userProfileFromMap.lookingFor, 'Friendship and fun');
      expect(userProfileFromMap.imageUrl, 'http://example.com/image.jpg');
      expect(userProfileFromMap.location, 'New York');
      expect(userProfileFromMap.hobbies, contains('Reading'));
      expect(userProfileFromMap.hobbies, contains('Swimming'));
      expect(userProfileFromMap.joinedEventsIds, contains('event1'));
      expect(userProfileFromMap.joinedEventsIds, contains('event2'));
    });
  });
}
