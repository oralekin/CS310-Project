import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/chat_store.dart';
import '../models/chat_message.dart';
import '../providers/auth_provider.dart';

class ChatScreenArguments {
  final String eventId;
  final String title;

  const ChatScreenArguments({
    required this.eventId,
    required this.title,
  });
}

class ChatScreen extends StatefulWidget {
  static const routeName = '/chat';

  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  Future<void> _sendMessage(
      String eventId,
      String userId,
      ) async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    await ChatStore.sendMessage(
      eventId: eventId,
      text: text,
      senderId: userId,
    );

    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args =
    ModalRoute.of(context)!.settings.arguments as ChatScreenArguments;

    final user = context.read<AuthProvider>().user!;
    final eventId = args.eventId;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: SafeArea(
        child: Column(
          children: [
            // 🔹 HEADER
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Text(
                      args.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 🔹 MESSAGES
            Expanded(
              child: StreamBuilder<List<ChatMessage>>(
                stream: ChatStore.streamMessages(eventId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                        child: CircularProgressIndicator());
                  }

                  final messages = snapshot.data!;

                  return ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: messages.length,
                    itemBuilder: (_, i) {
                      final m = messages[i];
                      final isMe = m.senderId == user.uid;

                      return Align(
                        alignment: isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            color: isMe
                                ? const Color(0xFFCFF5C2)
                                : const Color(0xFFEDEDED),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            m.text,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // 🔹 INPUT
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.black12)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: "Type a message...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () =>
                        _sendMessage(eventId, user.uid),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
