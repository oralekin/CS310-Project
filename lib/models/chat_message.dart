import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String id;
  final String text;
  final String senderId;
  final DateTime createdAt;

  ChatMessage({
    required this.id,
    required this.text,
    required this.senderId,
    required this.createdAt,
  });

  factory ChatMessage.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc,
      ) {
    final data = doc.data()!;
    return ChatMessage(
      id: doc.id,
      text: data['text'],
      senderId: data['senderId'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'text': text,
      'senderId': senderId,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
