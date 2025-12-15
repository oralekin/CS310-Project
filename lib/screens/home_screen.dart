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

  List<EventModel> get _filteredEvents {
    return globalEvents.where((e) {
      if (_query != null && _query!.isNotEmpty) {
        if (!e.title.toLowerCase().contains(_query!.toLowerCase())) {
          return false;
        }
      }

      if (_categories.isNotEmpty && !_categories.contains(e.category)) {
        return false;
      }

      return true;
    }).toList();
  }

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
    return Scaffold(
      backgroundColor: Colors.white,

      // ───────── HEADER ─────────
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
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
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // POPULAR EVENTS
                    const Text(
                      "Popular Events",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),

                    SizedBox(
                      height: 130,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (_, __) => const _PopularEventCard(),
                        separatorBuilder: (_, __) =>
                        const SizedBox(width: 12),
                        itemCount: 3,
                      ),
                    ),

                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 16),

                    // NEW EVENTS
                    const Text(
                      "New Events",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Column(
                      children: _filteredEvents
                          .map(
                            (event) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _NewEventCard(event: event),
                        ),
                      )
                          .toList(),
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
            // HOME
            IconButton(
              icon: const Icon(Icons.home_outlined),
              onPressed: () {
                // zaten home'dayız
              },
            ),

            // PROFILE ✅
            IconButton(
              icon: const Icon(Icons.person_outline),
              onPressed: () {
                Navigator.pushNamed(context, ProfileScreen.routeName);
              },
            ),

            // CHAT
            IconButton(
              icon: const Icon(Icons.chat_bubble_outline),
              onPressed: () {
                Navigator.pushNamed(context, ChatScreen.routeName);
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
  const _PopularEventCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      child: const Column(
        children: [
          Icon(Icons.image_outlined, size: 48),
          SizedBox(height: 8),
          Text("Event Title"),
        ],
      ),
    );
  }
}

// ───────── NEW EVENT CARD → DETAILS ─────────
class _NewEventCard extends StatelessWidget {
  final EventModel event;

  const _NewEventCard({required this.event});

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
            const Icon(Icons.image_outlined, size: 50),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
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
