class Event {
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

  // Convert to a map
  Map<String, dynamic> toMap() {
    return {
      'eventId': eventId,
      'ownerUserId': hostUserId,
      'hostName': hostName,
      'description': description,
      'eventDate': eventDate.toIso8601String(),
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'city': city,
      'postcode': postcode,
      'numberOfParticipants': numberOfParticipants,
      'participantUserIds': participantUserIds,
    };
  }

  // Construct an Event from a map
  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      eventId: map['eventId'],
      hostUserId: map['ownerUserId'],
      hostName: map['hostName'],
      description: map['description'],
      eventDate: DateTime.parse(map['eventDate']),
      addressLine1: map['addressLine1'],
      addressLine2: map['addressLine2'],
      city: map['city'],
      postcode: map['postcode'],
      numberOfParticipants: map['numberOfParticipants'],
      participantUserIds: List<String>.from(map['participantUserIds']),
    );
  }
}
