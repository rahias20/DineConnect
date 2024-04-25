class Event {
  // Properties defining the event details
  final String eventId;
  final String hostUserId;
  final String hostName;
  final String description;
  final DateTime eventDate;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String postcode;
  final int numberOfParticipants;
  final List<String> participantUserIds;

  // Constructor for creating a new Event object
  Event({
    required this.eventId,
    required this.hostUserId,
    required this.hostName,
    required this.description,
    required this.eventDate,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.postcode,
    required this.numberOfParticipants,
    required this.participantUserIds,
  });

  // Converts an Event object into a Map, which is useful for serialization
  Map<String, dynamic> toMap() {
    return {
      'eventId': eventId,
      'ownerUserId': hostUserId,
      'hostName': hostName,
      'description': description,
      'eventDate': eventDate
          .toIso8601String(), // Converts DateTime to a string in ISO-8601 format
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'city': city,
      'postcode': postcode,
      'numberOfParticipants': numberOfParticipants,
      'participantUserIds':
          participantUserIds, // A list of participant IDs who joined the event
    };
  }

  // Factory constructor to create an Event object from a map (deserialization)
  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      eventId: map['eventId'],
      hostUserId: map['ownerUserId'],
      hostName: map['hostName'],
      description: map['description'],
      eventDate: DateTime.parse(
          map['eventDate']), // Parses the string back into a DateTime object
      addressLine1: map['addressLine1'],
      addressLine2: map['addressLine2'],
      city: map['city'],
      postcode: map['postcode'],
      numberOfParticipants: map['numberOfParticipants'],
      participantUserIds: List<String>.from(map[
          'participantUserIds']), // Ensures the list type is correctly maintained
    );
  }
}
