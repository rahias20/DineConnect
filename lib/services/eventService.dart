import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_connect/models/event.dart';

class EventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // save event data in the database
  Future<void> saveEvent(Event event) async {
    DocumentReference eventRef =
        _firestore.collection('events').doc(event.eventId);
    DocumentReference userProfileRef =
        _firestore.collection('userProfiles').doc(event.hostUserId);

    await _firestore.runTransaction((transaction) async {
      // Set the event data
      transaction.set(eventRef, event.toMap());

      // Append eventId to the user's list of joinedEventsIds
      transaction.update(userProfileRef, {
        'joinedEventsIds': FieldValue.arrayUnion([event.eventId])
      });
    });
  }

  // fetch event data from the database
  Future<Event?> fetchEvent(String eventId) async {
    try {
      DocumentSnapshot eventSnapshot =
          await _firestore.collection('events').doc(eventId).get();
      if (eventSnapshot.exists) {
        return Event.fromMap(eventSnapshot.data() as Map<String, dynamic>);
      }
    } catch (e) {
      throw Exception("Error fetching event: $e");
    }
    return null;
  }

  // update event data in the database
  Future<void> updateEvent(Event event) async {
    try {
      await _firestore
          .collection('events')
          .doc(event.eventId)
          .update(event.toMap());
    } catch (e) {
      throw Exception("Error updating event: $e");
    }
  }

  // delete event from the database
  Future<void> deleteEvent(String eventId) async {
    await _firestore.collection('events').doc(eventId).delete();
  }

  // ddd participant to event
  Future<void> addParticipant(String eventId, String userId) async {
    DocumentReference eventRef = _firestore.collection('events').doc(eventId);
    DocumentReference userProfileRef =
        _firestore.collection('userProfiles').doc(userId);

    await _firestore.runTransaction((transaction) async {
      // First, perform the read operation
      DocumentSnapshot eventSnapshot = await transaction.get(eventRef);
      DocumentSnapshot userProfileSnapshot =
          await transaction.get(userProfileRef);

      // then, you can proceed with the write operations
      if (eventSnapshot.exists) {
        List<dynamic> participantUserIds =
            List.from(eventSnapshot.get('participantUserIds') ?? []);
        if (!participantUserIds.contains(userId)) {
          transaction.update(eventRef, {
            'participantUserIds': FieldValue.arrayUnion([userId])
          });
        }
      }

      if (userProfileSnapshot.exists) {
        List<dynamic> joinedEventsIds =
            List.from(userProfileSnapshot.get('joinedEventsIds') ?? []);
        if (!joinedEventsIds.contains(eventId)) {
          transaction.update(userProfileRef, {
            'joinedEventsIds': FieldValue.arrayUnion([eventId])
          });
        }
      } else {
        // Handle the case where the user profile does not exist
        // Perhaps you might want to create a new document or log an error
      }
    });
  }

  // remove participant from event
  Future<void> removeParticipant(String eventId, String userId) async {
    // references to the documents
    DocumentReference eventRef = _firestore.collection('events').doc(eventId);
    DocumentReference userProfileRef =
        _firestore.collection('userProfiles').doc(userId);

    await _firestore.runTransaction((transaction) async {
      // perform the read operations first
      DocumentSnapshot eventSnapshot = await transaction.get(eventRef);
      DocumentSnapshot userProfileSnapshot =
          await transaction.get(userProfileRef);

      if (eventSnapshot.exists && userProfileSnapshot.exists) {
        // Remove the userId from the event's participantUserIds array
        List<dynamic> participants =
            List.from(eventSnapshot.get('participantUserIds') ?? []);
        participants.remove(userId);
        transaction.update(eventRef, {'participantUserIds': participants});

        // Remove the eventId from the user's joinedEventsIds array
        List<dynamic> joinedEvents =
            List.from(userProfileSnapshot.get('joinedEventsIds') ?? []);
        joinedEvents.remove(eventId);
        transaction.update(userProfileRef, {'joinedEventsIds': joinedEvents});
      } else {
        throw Exception("Event or UserProfile does not exist");
      }
    }).catchError((e) {
      throw Exception("Error removing participant: $e");
    });
  }

  // fetch all events created by a specific user
  Future<List<Event>> fetchEventsCreatedByUser(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('events')
          .where('ownerUserId', isEqualTo: userId)
          .orderBy('eventDate')
          .get();

      List<Event> events = querySnapshot.docs
          .map((doc) => Event.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      return events;
    } catch (e) {
      throw Exception("Error fetching events: $e");
    }
  }

  // fetch events in the specified city with open slots for participants
  Future<List<Event>> fetchEventsInCity(String city, String userId) async {
    try {
      final now = DateTime.now();
      final isoDateNow = now.toIso8601String();
      QuerySnapshot querySnapshot = await _firestore
          .collection('events')
          .where('city', isEqualTo: city)
          .where('eventDate', isGreaterThan: isoDateNow)
          .orderBy('eventDate')
          .get();

      // filter out events that the user has already joined
      List<Event> events = [];
      for (var doc in querySnapshot.docs) {
        var event = Event.fromMap(doc.data() as Map<String, dynamic>);
        if (event.hostUserId != userId &&
            !event.participantUserIds.contains(userId) &&
            (event.participantUserIds.length + 1 <
                event.numberOfParticipants)) {
          events.add(event);
        }
      }

      return events;
    } catch (e) {
      throw Exception("Error fetching events in city: $e");
    }
  }

  // fetch events that a specific user has joined
  Future<List<Event>> fetchJoinedEventsByUser(String userId) async {
    try {
      // Assuming your events collection has a 'participantUserIds' field which is an array of user IDs
      QuerySnapshot querySnapshot = await _firestore
          .collection('events')
          .where('participantUserIds', arrayContains: userId)
          .orderBy('eventDate')
          .get();

      List<Event> events = querySnapshot.docs
          .map((doc) => Event.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      return events;
    } catch (e) {
      throw Exception("Error fetching joined events: $e");
    }
  }
}
