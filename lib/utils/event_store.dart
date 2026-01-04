import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final DateTime date;
  final String time;
  final String location;
  final String university;
  final String ownerId;
  final bool isApproved;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.date,
    required this.time,
    required this.location,
    required this.university,
    required this.ownerId,
    required this.isApproved,
  });

  /// 🔹 Firestore → EventModel
  factory EventModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return EventModel(
      id: doc.id,
      title: data['title'],
      description: data['description'],
      category: data['category'],
      date: (data['date'] as Timestamp).toDate(),
      time: data['time'],
      location: data['location'],
      university: data['university'],
      ownerId: data['ownerId'],
      isApproved: data['isApproved'] ?? false,
    );
  }

  /// 🔹 EventModel → Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'date': Timestamp.fromDate(date),
      'time': time,
      'location': location,
      'university': university,
      'ownerId': ownerId,
      'isApproved': isApproved,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
