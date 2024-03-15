

class Event {
  final String eventId;
  final String ownerUserId;
  final String title;
  final String description;
  final DateTime eventDate;
  final String location;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String postcode;
  final int numberOfParticipants;
  final List<String> participantUserIds;

  Event({
    required this.eventId,
    required this.ownerUserId,
    required this.title,
    required this.description,
    required this.eventDate,
    required this.location,
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
      'ownerUserId': ownerUserId,
      'title': title,
      'description': description,
      'eventDate': eventDate.toIso8601String(),
      'location': location,
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
      ownerUserId: map['ownerUserId'],
      title: map['title'],
      description: map['description'],
      eventDate: DateTime.parse(map['eventDate']),
      location: map['location'],
      addressLine1: map['addressLine1'],
      addressLine2: map['addressLine2'],
      city: map['city'],
      postcode: map['postcode'],
      numberOfParticipants: map['numberOfParticipants'],
      participantUserIds: List<String>.from(map['participantUserIds']),
    );
  }
}
