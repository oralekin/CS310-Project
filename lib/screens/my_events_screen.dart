import 'package:flutter/material.dart';
import 'event_store.dart';
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

      appBar: AppBar(
        title: const Text("My Events", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            const Text(
              "My Events",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),

            const SizedBox(height: 25),

            if (myEvents.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: myEvents.length,
                  itemBuilder: (context, index) {
                    final e = myEvents[index];
                    return Container(
                      padding: const EdgeInsets.all(14),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.event, size: 40, color: Colors.black54),
                          const SizedBox(width: 12),

                          Expanded(
                            child: Text(
                              e.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                EventDetailsScreen.routeName,
                              );
                            },
                            child: const Text(
                              "View Details",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            else
              Center(
                child: Column(
                  children: [
                    Icon(Icons.event_note, size: 70, color: Colors.grey.shade400),
                    const SizedBox(height: 15),
                    const Text("You have no events yet.", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
