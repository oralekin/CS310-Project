import 'package:flutter/material.dart';
import 'event store.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/userHome',
      routes: {
        '/userHome': (context) => const UserHomeScreen(),
        '/eventDetails': (context) => const Placeholder(),
        '/chat': (context) => const Placeholder(),
        '/userProfile': (context) => const Placeholder(),
      },
    );
  }
}

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: const Color(0xFFE0E0E0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'UniConnect',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search Event',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/userProfile');
                      },
                      icon: const Icon(Icons.person_outline, color: Colors.black87),
                      label: const Text(
                        'My Profile',
                        style: TextStyle(color: Colors.black87),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Popular Events',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _PopularEventCard(
                            onTap: () {},
                          ),
                          const SizedBox(width: 12),
                          _PopularEventCard(
                            onTap: () {},
                          ),
                          const SizedBox(width: 12),
                          _PopularEventCard(
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(thickness: 1),
                    const SizedBox(height: 12),
                    const Text(
                      'New Events',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (globalEvents.isNotEmpty)
                      Column(
                        children: [
                          for (final event in globalEvents)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _CreatedEventCard(
                                event: event,
                                onTap: () {},
                              ),
                            ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          _NewEventCard(onTap: () {}),
                          const SizedBox(height: 10),
                          _NewEventCard(onTap: () {}),
                          const SizedBox(height: 10),
                          _NewEventCard(onTap: () {}),
                        ],
                      ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/userHome');
              },
              icon: const Icon(Icons.home_filled),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/chat');
              },
              icon: const Icon(Icons.chat_bubble_outline),
            ),
          ],
        ),
      ),
    );
  }
}

class _PopularEventCard extends StatelessWidget {
  final VoidCallback onTap;

  const _PopularEventCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          children: [
            Container(
              height: 70,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(
                  Icons.image_outlined,
                  size: 32,
                  color: Colors.black54,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Event Title',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _NewEventCard extends StatelessWidget {
  final VoidCallback onTap;

  const _NewEventCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(
                  Icons.image_outlined,
                  size: 28,
                  color: Colors.black54,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Event Title   |   Date & Location',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Event Description & Host Name',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
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

class _CreatedEventCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback onTap;

  const _CreatedEventCard({
    required this.event,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.event,
                      size: 28,
                      color: Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${event.title}   |   ${event.date} ${event.time}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${event.location}  •  ${event.category}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        event.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 6,
          top: 6,
          child: GestureDetector(
            onTap: () {
              if (!myEvents.contains(event)) {
                myEvents.add(event);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Event added to My Events'),
                    duration: Duration(seconds: 1),
                  ),
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 18),
            ),
          ),
        ),
      ],
    );
  }
}
