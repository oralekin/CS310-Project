import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:uniconnect/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final db = FirebaseFirestore.instance;
  final events = await db.collection('events').get();
  var updatedCount = 0;

  for (final event in events.docs) {
    final messagesRef = db
        .collection('events')
        .doc(event.id)
        .collection('messages');

    final messages = await messagesRef.get();
    for (final message in messages.docs) {
      final data = message.data();
      if (data['senderName'] != null && data['senderRole'] != null) {
        continue;
      }

      final senderId = data['senderId']?.toString();
      if (senderId == null || senderId.isEmpty) {
        continue;
      }

      final userDoc = await db.collection('users').doc(senderId).get();
      final userData = userDoc.data() ?? {};
      final senderName = (userData['fullName'] ?? '').toString();
      final senderRole = (userData['role'] ?? '').toString();

      await message.reference.update({
        'senderName': senderName,
        'senderRole': senderRole,
      });
      updatedCount++;
    }
  }

  // ignore: avoid_print
  print('Migration complete. Updated messages: $updatedCount');
}
