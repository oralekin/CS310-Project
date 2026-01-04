import 'package:flutter/material.dart';
import '../models/event_store.dart';
import 'search_filter_screen.dart';
import 'event_details_screen.dart';
import 'profile_screen.dart';
import 'chat_screen.dart';

class UserHomeScreen extends StatefulWidget {
  static const routeName = "/userHome";

  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  String? _query;
  List<String> _categories = [];

  Future<void> _openFilters() async {
    final result = await Navigator.pushNamed(
      context,
      SearchFilterScreen.routeName,
    );

    if (result != null && result is Map) {
      setState(() {
        _query = result["query"];
        _categories = List<String>.from(result["categories"] ?? []);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width >= 600;
    final horizontalPadding = isWide ? 24.0 : 16.0;
    final popularCardWidth = isWide ? 160.0 : 120.0;
    final popularListHeight = isWide ? 160.0 : 130.0;

    return Scaffold(
      backgroundColor: Colors.white,

      // ───────── HEADER ─────────
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                16,
                horizontalPadding,
                12,
              ),
              color: const Color(0xFFE5E5E5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "UniConnect",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  GestureDetector(
                    onTap: _openFilters,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.search, size: 18),
                          SizedBox(width: 6),
                          Text("Search Event"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ───────── CONTENT ─────────
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // POPULAR EVENTS (mock)
                    const Text(
                      "Popular Events",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),

                    SizedBox(
                      height: popularListHeight,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (_, __) => _PopularEventCard(
                          width: popularCardWidth,
                        ),
                        separatorBuilder: (_, __) =>
                        const SizedBox(width: 12),
                        itemCount: 3,
                      ),
                    ),

                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 16),

                    // ───────── NEW EVENTS (🔥 FIRESTORE REALTIME) ─────────
                    const Text(
                      "New Events",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),

                    StreamBuilder<List<EventModel>>(
                      stream: EventStore.streamApprovedEvents(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        if (snapshot.hasError) {
                          return const Text("Something went wrong.");
                        }


                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Text("No events yet.");
                        }

                        final events = snapshot.data!.where((e) {
                          if (_query != null && _query!.isNotEmpty) {
                            if (!e.title
                                .toLowerCase()
                                .contains(_query!.toLowerCase())) {
                              return false;
                            }
                          }

                          if (_categories.isNotEmpty &&
                              !_categories.contains(e.category)) {
                            return false;
                          }

                          return true;
                        }).toList();

                        return Column(
                          children: events
                              .map(
                                (event) => Padding(
                              padding:
                              const EdgeInsets.only(bottom: 12),
                              child: _NewEventCard(event: event),
                            ),
                          )
                              .toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // ───────── BOTTOM NAV ─────────
      bottomNavigationBar: Container(
        height: 64,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.black12)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.home_outlined),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.person_outline),
              onPressed: () {
                Navigator.pushNamed(context, ProfileScreen.routeName);
              },
            ),
            IconButton(
              icon: const Icon(Icons.chat_bubble_outline),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Open an event to access its chat."),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ───────── POPULAR CARD (mock) ─────────
class _PopularEventCard extends StatelessWidget {
  final double width;

  const _PopularEventCard({required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              'images/download.jpg',
              height: 70,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          const Text("Event Title"),
        ],
      ),
    );
  }
}

// ───────── EVENT CARD → DETAILS ─────────
class _NewEventCard extends StatelessWidget {
  final EventModel event;

  const _NewEventCard({required this.event});

  static const _previewImageUrl =
      'https://images.unsplash.com/photo-1523580846011-d3a5bc25702b?w=400';

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EventDetailsScreen(event: event),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                _previewImageUrl,
                height: 50,
                width: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image_outlined, size: 50);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style:
                    const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${event.time} • ${event.location}",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    event.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
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
