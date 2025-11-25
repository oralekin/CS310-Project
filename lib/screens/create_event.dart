import 'package:flutter/material.dart';
import 'event_store.dart';

class CreateEventScreen extends StatefulWidget {
  static const routeName = "/createEvent";

  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final titleCtrl = TextEditingController();
  final locationCtrl = TextEditingController();
  final categoryCtrl = TextEditingController();
  final dateCtrl = TextEditingController();
  final timeCtrl = TextEditingController();
  final descCtrl = TextEditingController();

  void saveEvent() {
    final event = EventModel(
      title: titleCtrl.text,
      location: locationCtrl.text,
      category: categoryCtrl.text,
      date: dateCtrl.text,
      time: timeCtrl.text,
      description: descCtrl.text,
    );

    myEvents.add(event);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Event Created!")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Event")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: "Event Title")),
            TextField(controller: locationCtrl, decoration: const InputDecoration(labelText: "Location")),
            TextField(controller: categoryCtrl, decoration: const InputDecoration(labelText: "Category")),
            TextField(controller: dateCtrl, decoration: const InputDecoration(labelText: "Date")),
            TextField(controller: timeCtrl, decoration: const InputDecoration(labelText: "Time")),
            TextField(controller: descCtrl, decoration: const InputDecoration(labelText: "Description")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveEvent,
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
