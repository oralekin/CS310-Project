import 'package:cloud_firestore/cloud_firestore.dart';

/// 🔹 EVENT MODEL
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

  /// 🔥 Firestore → Model
  factory EventModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc,
      ) {
    final data = doc.data()!;
    return EventModel(
      id: doc.id,
      title: data['title'],
      category: data['category'],
      date: (data['date'] as Timestamp).toDate(),
      time: data['time'],
      location: data['location'],
      university: data['university'] ?? '',
      description: data['description'],
      ownerId: data['ownerId'],
      isApproved: data['isApproved'] ?? false,
    );
  }

  /// 🔥 Model → Firestore
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
      identical(this, other) ||
          other is EventModel && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

/// 🔥 FIRESTORE EVENT STORE
class EventStore {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final CollectionReference<Map<String, dynamic>> _eventsRef =
  _db.collection('events');

  // ───────────────── USER EVENTS ─────────────────

  /// ✅ REALTIME: SADECE ONAYLI event’ler (USER HOME FEED)
  static Stream<List<EventModel>> streamApprovedEvents() {
    return _eventsRef
        .where('isApproved', isEqualTo: true)
        .orderBy('date')
        .snapshots()
        .map(
          (snapshot) =>
          snapshot.docs.map(EventModel.fromFirestore).toList(),
    );
  }

  /// ✅ REALTIME: Kullanıcının OLUŞTURDUĞU event’ler
  static Stream<List<EventModel>> streamMyEvents(String userId) {
    return _eventsRef
        .where('ownerId', isEqualTo: userId)
        .snapshots()
        .map(
          (snapshot) =>
          snapshot.docs.map(EventModel.fromFirestore).toList(),
    );
  }

  /// ✅ CREATE EVENT
  static Future<void> addEvent(EventModel event) {
    return _eventsRef.add(event.toFirestore());
  }

  // ───────────────── ADMIN (APPROVAL FLOW) ─────────────────

  /// 👑 ADMIN: Onay BEKLEYEN event’ler
  static Stream<List<EventModel>> streamPendingEvents() {
    return _eventsRef.snapshots().map(
          (snapshot) => snapshot.docs
              .map(EventModel.fromFirestore)
              .where((event) => !event.isApproved)
              .toList(),
        );
  }

  /// 👑 ADMIN: Event onayla
  static Future<void> approveEvent(String eventId) {
    return _eventsRef.doc(eventId).update({'isApproved': true});
  }

  /// 👑 ADMIN: Event sil
  static Future<void> deleteEvent(String eventId) {
    return _eventsRef.doc(eventId).delete();
  }

  // ───────────────── ATTENDANCE (STEP 5) ─────────────────

  /// 🔹 Realtime: kullanıcı bu event’e katılıyor mu?
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

  /// 🔹 Event’e katıl
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

  /// 🔹 Event’ten ayrıl
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

  /// ✅ REALTIME: Attendee sayısı
  static Stream<int> streamAttendeeCount(String eventId) {
    return _eventsRef
        .doc(eventId)
        .collection('attendees')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  // ───────────────── JOINED EVENTS (STEP 5.4) ─────────────────

  /// ✅ REALTIME: Kullanıcının KATILDIĞI event’ler
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
          joinedEvents.add(EventModel.fromFirestore(doc));
        }
      }

      return joinedEvents;
    });
  }
}


