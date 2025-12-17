import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/event_store.dart';
import '../providers/auth_provider.dart';
import '../screens/chat_screen.dart';
import 'package:uniconnect/widgets/expandable_text.dart';

class EventDetailsScreen extends StatelessWidget {
  static const routeName = "/details";

  final EventModel event;

  const EventDetailsScreen({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthProvider>().user;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          /// 🔹 HEADER (IMAGE + BACK + GOING)
          SliverPersistentHeader(
            pinned: true,
            delegate: _EventHeader(
              eventId: event.id,
              userId: user?.uid,
            ),
          ),

          /// 🔹 CONTENT
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TITLE
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // META
                  _InfoRow(
                    icon: Icons.category_outlined,
                    text: event.category,
                  ),
                  _InfoRow(
                    icon: Icons.pin_drop_outlined,
                    text: event.location,
                  ),
                  _InfoRow(
                    icon: Icons.calendar_today_outlined,
                    text: "${_fmtDate(event.date)} • ${event.time}",
                  ),

                  // 🔥 REALTIME ATTENDEE COUNT
                  StreamBuilder<int>(
                    stream: EventStore.streamAttendeeCount(event.id),
                    builder: (context, snapshot) {
                      final count = snapshot.data ?? 0;
                      return _InfoRow(
                        icon: Icons.people_outline,
                        text: "$count people going",
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // DESCRIPTION
                  ExpandableText(
                    allowed: 3,
                    str: event.description,
                  ),

                  const SizedBox(height: 28),

                  // 🔥 CHAT BUTTON (STEP 9)
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.chat_bubble_outline),
                      label: const Text("Open Event Chat"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          ChatScreen.routeName,
                          arguments: ChatScreenArguments(
                            eventId: event.id,
                            title: event.title,
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 32),

                  // GALLERY (mock)
                  const Text(
                    "Gallery",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 6,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemBuilder: (_, __) => Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.image_outlined,
                        size: 40,
                        color: Colors.black38,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _fmtDate(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yy = d.year.toString();
    return "$dd/$mm/$yy";
  }
}

/// ───────────────── HEADER ─────────────────
class _EventHeader extends SliverPersistentHeaderDelegate {
  final String eventId;
  final String? userId;

  _EventHeader({
    required this.eventId,
    required this.userId,
  });

  @override
  double get maxExtent => 280;

  @override
  double get minExtent => 110;

  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent,
      ) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // IMAGE PLACEHOLDER
        Container(
          color: Colors.grey[300],
          alignment: Alignment.center,
          child: const Icon(
            Icons.image,
            size: 90,
            color: Colors.black45,
          ),
        ),

        // BACK BUTTON
        Positioned(
          top: 40,
          left: 16,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),

        // 🔥 GOING BUTTON (REALTIME)
        if (userId != null)
          Positioned(
            right: 16,
            bottom: 16,
            child: StreamBuilder<bool>(
              stream: EventStore.isUserGoing(
                eventId: eventId,
                userId: userId!,
              ),
              builder: (context, snapshot) {
                final isGoing = snapshot.data ?? false;

                return ElevatedButton.icon(
                  onPressed: () async {
                    if (isGoing) {
                      await EventStore.leaveEvent(
                        eventId: eventId,
                        userId: userId!,
                      );
                    } else {
                      await EventStore.joinEvent(
                        eventId: eventId,
                        userId: userId!,
                      );
                    }
                  },
                  icon: Icon(isGoing ? Icons.check : Icons.close),
                  label: Text(isGoing ? "Going" : "Not Going"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    isGoing ? Colors.purple[100] : Colors.red[100],
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}

/// ───────────────── INFO ROW ─────────────────
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.black54),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
