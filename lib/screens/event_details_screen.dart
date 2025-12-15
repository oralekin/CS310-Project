import 'package:flutter/material.dart';
import '../models/event_store.dart';
import 'package:uniconnect/widgets/expandable_text.dart';

class EventDetailsScreen extends StatefulWidget {
  static const routeName = "/details";

  final EventModel event;

  const EventDetailsScreen({
    super.key,
    required this.event,
  });

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  bool going = false;

  @override
  Widget build(BuildContext context) {
    final e = widget.event;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          /// 🔹 IMAGE HEADER (FIGMA STYLE)
          SliverPersistentHeader(
            pinned: true,
            delegate: _EventHeader(
              going: going,
              onToggle: () => setState(() => going = !going),
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
                    e.title,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // META
                  _InfoRow(
                    icon: Icons.category_outlined,
                    text: e.category,
                  ),
                  _InfoRow(
                    icon: Icons.pin_drop_outlined,
                    text: e.location,
                  ),
                  _InfoRow(
                    icon: Icons.calendar_today_outlined,
                    text: "${_fmtDate(e.date)} • ${e.time}",
                  ),

                  const SizedBox(height: 20),

                  // DESCRIPTION
                  ExpandableText(
                    allowed: 3,
                    str: e.description,
                  ),

                  const SizedBox(height: 32),

                  // GALLERY
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

/// 🔹 HEADER (IMAGE + BACK + GOING)
class _EventHeader extends SliverPersistentHeaderDelegate {
  final bool going;
  final VoidCallback onToggle;

  _EventHeader({
    required this.going,
    required this.onToggle,
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

        // GOING BUTTON
        Positioned(
          right: 16,
          bottom: 16,
          child: ElevatedButton.icon(
            onPressed: onToggle,
            icon: Icon(going ? Icons.check : Icons.close),
            label: Text(going ? "Going" : "Not Going"),
            style: ElevatedButton.styleFrom(
              backgroundColor:
              going ? Colors.purple[100] : Colors.red[100],
              foregroundColor: Colors.black,
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}

/// 🔹 INFO ROW
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
