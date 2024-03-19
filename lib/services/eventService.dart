import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_connect/models/event.dart';

class EventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // save event data in the database
  Future<void> saveEvent(Event event) async {
    await _firestore.collection('events').doc(event.eventId).set(event.toMap());
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
    try {
      await _firestore.collection('events').doc(eventId).update({
        'participantUserIds': FieldValue.arrayUnion([userId])
      });
    } catch (e) {
      throw Exception("Error adding participant: $e");
    }
  }

  // Remove participant from event
  Future<void> removeParticipant(String eventId, String userId) async {
    try {
      await _firestore.collection('events').doc(eventId).update({
        'participants': FieldValue.arrayRemove([userId])
      });
    } catch (e) {
      throw Exception("Error removing participant: $e");
    }
  }

  // fetch all events created by a specific user
  Future<List<Event>> fetchEventsCreatedByUser(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('events')
          .where('ownerUserId', isEqualTo: userId)
          .get();

      List<Event> events = querySnapshot.docs
          .map((doc) => Event.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      return events;
    } catch (e) {
      throw Exception("Error fetching events: $e");
    }
  }

  // fetch events in the specified city
  Future<List<Event>> fetchEventsInCity(String city) async {
    try {
      final now = DateTime.now();
      final isoDateNow = now.toIso8601String();
      QuerySnapshot querySnapshot = await _firestore
          .collection('events')
          .where('city', isEqualTo: city)
          .where('eventDate', isGreaterThan: isoDateNow)
          .orderBy('eventDate')
          .get();

      List<Event> events = querySnapshot.docs
          .map((doc) => Event.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      return events;
    } catch (e) {
      throw Exception("Error fetching events in city: $e");
    }
  }
}
