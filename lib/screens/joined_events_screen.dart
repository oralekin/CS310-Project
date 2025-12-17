import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/event_store.dart';
import '../providers/auth_provider.dart';
import 'event_details_screen.dart';

class JoinedEventsScreen extends StatelessWidget {
  static const routeName = "/joinedEvents";

  const JoinedEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthProvider>().user;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("User not logged in")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Joined Events"),
        centerTitle: true,
      ),
      body: StreamBuilder<List<EventModel>>(
        stream: EventStore.streamJoinedEvents(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("You haven't joined any events yet."),
            );
          }

          final events = snapshot.data!;

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final e = events[index];

              return ListTile(
                title: Text(e.title),
                subtitle: Text("${e.time} • ${e.location}"),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EventDetailsScreen(event: e),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
