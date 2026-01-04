import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_message.dart';

class ChatStore {
  static final _db = FirebaseFirestore.instance;

  static CollectionReference<Map<String, dynamic>> _messagesRef(
      String eventId,
      ) {
    return _db
        .collection('events')
        .doc(eventId)
        .collection('messages');
  }

  /// 🔥 Realtime messages
  static Stream<List<ChatMessage>> streamMessages(String eventId) {
    return _messagesRef(eventId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
          snapshot.docs.map(ChatMessage.fromFirestore).toList(),
    );
  }

  /// ✉️ Send message
  static Future<void> sendMessage({
    required String eventId,
    required String text,
    required String senderId,
  }) {
    return _db
        .collection('users')
        .doc(senderId)
        .get()
        .then((snapshot) {
      final data = snapshot.data() ?? {};
      final senderName = (data['fullName'] ?? '').toString();
      final senderRole = (data['role'] ?? '').toString();
      return _messagesRef(eventId).add({
        'text': text,
        'senderId': senderId,
        'senderName': senderName,
        'senderRole': senderRole,
        'createdAt': FieldValue.serverTimestamp(),
      });
    });
  }
}
