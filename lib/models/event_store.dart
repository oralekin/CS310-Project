import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String id;
  final String title;
  final String category;
  final DateTime date;
  final String time;
  final String location;
  final String university;
  final String description;
  final String ownerId;
  final bool isApproved;

  EventModel({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.time,
    required this.location,
    required this.university,
    required this.description,
    required this.ownerId,
    required this.isApproved,
  });

  factory EventModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    final dateValue = data['date'];
    final parsedDate = dateValue is Timestamp
        ? dateValue.toDate()
        : DateTime.fromMillisecondsSinceEpoch(0);

    return EventModel(
      id: doc.id,
      title: (data['title'] ?? '').toString(),
      category: (data['category'] ?? '').toString(),
      date: parsedDate,
      time: (data['time'] ?? '').toString(),
      location: (data['location'] ?? '').toString(),
      university: (data['university'] ?? '').toString(),
      description: (data['description'] ?? '').toString(),
      ownerId: (data['ownerId'] ?? '').toString(),
      isApproved: data['isApproved'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'category': category,
      'date': Timestamp.fromDate(date),
      'time': time,
      'location': location,
      'university': university,
      'description': description,
      'ownerId': ownerId,
      'isApproved': isApproved,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is EventModel && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

class EventStore {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final CollectionReference<Map<String, dynamic>> _eventsRef =
      _db.collection('events');

  static EventModel? _tryFromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    try {
      return EventModel.fromFirestore(doc);
    } catch (_) {
      return null;
    }
  }

  static Stream<List<EventModel>> streamApprovedEvents() {
    return _eventsRef
        .where('isApproved', isEqualTo: true)
        .orderBy('date')
        .snapshots()
        .map((snapshot) {
      final events = <EventModel>[];
      for (final doc in snapshot.docs) {
        final event = _tryFromFirestore(doc);
        if (event != null) {
          events.add(event);
        }
      }
      return events;
    });
  }

  static Stream<List<EventModel>> streamMyEvents(String userId) {
    return _eventsRef
        .where('ownerId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final events = <EventModel>[];
      for (final doc in snapshot.docs) {
        final event = _tryFromFirestore(doc);
        if (event != null) {
          events.add(event);
        }
      }
      return events;
    });
  }

  static Future<void> addEvent(EventModel event) {
    return _eventsRef.add(event.toFirestore());
  }

  static Stream<List<EventModel>> streamPendingEvents() {
    return _eventsRef.snapshots().map((snapshot) {
      final pendingEvents = <EventModel>[];
      for (final doc in snapshot.docs) {
        final event = _tryFromFirestore(doc);
        if (event != null && !event.isApproved) {
          pendingEvents.add(event);
        }
      }
      return pendingEvents;
    });
  }

  static Future<void> approveEvent(String eventId) {
    return _eventsRef.doc(eventId).update({'isApproved': true});
  }

  static Future<void> deleteEvent(String eventId) {
    return _eventsRef.doc(eventId).delete();
  }

  static Stream<bool> isUserGoing({
    required String eventId,
    required String userId,
  }) {
    return _eventsRef
        .doc(eventId)
        .collection('attendees')
        .doc(userId)
        .snapshots()
        .map((doc) => doc.exists);
  }

  static Future<void> joinEvent({
    required String eventId,
    required String userId,
  }) {
    return _eventsRef
        .doc(eventId)
        .collection('attendees')
        .doc(userId)
        .set({
      'joinedAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> leaveEvent({
    required String eventId,
    required String userId,
  }) {
    return _eventsRef
        .doc(eventId)
        .collection('attendees')
        .doc(userId)
        .delete();
  }

  static Stream<int> streamAttendeeCount(String eventId) {
    return _eventsRef
        .doc(eventId)
        .collection('attendees')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  static Stream<List<EventModel>> streamJoinedEvents(String userId) {
    return _eventsRef.snapshots().asyncMap((snapshot) async {
      final List<EventModel> joinedEvents = [];

      for (final doc in snapshot.docs) {
        final attendeeDoc = await _eventsRef
            .doc(doc.id)
            .collection('attendees')
            .doc(userId)
            .get();

        if (attendeeDoc.exists) {
          final event = _tryFromFirestore(doc);
          if (event != null) {
            joinedEvents.add(event);
          }
        }
      }

      return joinedEvents;
    });
  }
}
