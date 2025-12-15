import 'package:flutter/material.dart';

class ChatScreenArguments {
  final String categoryLabel;
  final String chatTitle;

  const ChatScreenArguments({
    required this.categoryLabel,
    required this.chatTitle,
  });
}

class ChatScreen extends StatefulWidget {
  static const routeName = '/chat';

  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, dynamic>> _messages = [
    {
      "text": "Hey everyone! Are you coming to the AI Workshop tomorrow? 🤖",
      "isMe": false,
    },
    {
      "text": "Yes! I just registered this morning 🙌",
      "isMe": true,
    },
    {
      "text": "Nice! Don’t forget to bring your laptop 💻",
      "isMe": false,
    },
  ];

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.insert(0, {"text": text, "isMe": true});
    });

    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildBubble(String text, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFFCFF5C2) : const Color(0xFFEDEDED),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args =
    ModalRoute.of(context)?.settings.arguments as ChatScreenArguments?;

    final categoryLabel = args?.categoryLabel ?? "Event Chat";
    final chatTitle = args?.chatTitle ?? "Chat";

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
                    child: Column(
                      children: [
                        Text(
                          categoryLabel,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          chatTitle,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 🔹 MESSAGES
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                reverse: true,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _messages.length,
                itemBuilder: (_, i) {
                  final m = _messages[i];
                  return _buildBubble(m["text"], m["isMe"]);
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
                    onPressed: _sendMessage,
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
