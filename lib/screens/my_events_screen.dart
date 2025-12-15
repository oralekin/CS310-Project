import 'package:flutter/material.dart';
import '../models/event_store.dart';
import 'event_details_screen.dart';

class MyEventsScreen extends StatefulWidget {
  static const routeName = "/myEvents";

  const MyEventsScreen({super.key});

  @override
  State<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// 🔹 APP BAR
      appBar: AppBar(
        title: const Text(
          "My Events",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      /// 🔹 BODY
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: myEvents.isNotEmpty
            ? ListView.builder(
          itemCount: myEvents.length,
          itemBuilder: (context, index) {
            final e = myEvents[index];

            return InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EventDetailsScreen(event: e),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.event,
                      size: 42,
                      color: Colors.black54,
                    ),
                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${e.time} • ${e.location}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Icon(
                      Icons.chevron_right,
                      color: Colors.black38,
                    ),
                  ],
                ),
              ),
            );
          },
        )
            : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.event_note,
                size: 72,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              const Text(
                "You have no events yet",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
