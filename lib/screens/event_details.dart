import 'package:flutter/material.dart';

import 'package:uniconnect/widgets/expandable_text.dart';

class Event {
  final String title;
  final String thumbnail;
  final Map<String, String> properties;
  final String description;
  final List<String> pictures;
  const Event({
    required this.title,
    required this.thumbnail,
    required this.properties,
    required this.description,
    required this.pictures,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      title: json['title'],
      thumbnail: json['thumbnail'],
      properties: Map<String, String>.from(json['properties']),
      description: json['description'],
      pictures: List<String>.from(json['pictures']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'thumbnail': thumbnail,
      'properties': properties,
      'description': description,
      'pictures': pictures,
    };
  }
}

final mockEvent = Event(
  properties: {
    "organizer": "Offtown Commitee",
    "location": "Behind Admin Building",
    "date": "25/04/2026",
  },
  description:
      "Quidem voluptatibus mollitia. Quia quae velit adipisci suscipit. Et amet facilis aut non totam. Placeat harum dignissimos aut in quas quo et nostrum. Pariatur vel iste libero ducimus necessitatibus. Fugit autem totam. Aut eveniet expedita perspiciatis amet rerum est. Quas iste alias et. Vero exercitationem quis voluptatum rerum illum eum. Inventore animi optio omnis dolor sunt est debitis nobis non. Sit rerum assumenda.",
  pictures: [
    "https://placehold.co/900x900jpg",
    "https://placehold.co/300x400jpg",
    "https://placehold.co/600x500jpg",
    "https://placehold.co/800x700jpg",
    "https://placehold.co/900x900jpg",
    "https://placehold.co/300x300jpg",
  ],
  thumbnail: "https://placehold.co/900x900jpg",
  title: "Offtown Festival",
);

IconData getPropertyIcon(String iconStr) {
  switch (iconStr) {
    case "organizer":
      return Icons.person_outline;
    case "location":
      return Icons.pin_drop_outlined;
    case "date":
      return Icons.calendar_today_outlined;
    default:
      return Icons.paste_outlined;
  }
}

class EventDetailsScreen extends StatelessWidget {
  const EventDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Event Details"), centerTitle: true),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: ShrinkingImageHeader(
              imageBuilder: (ctx) => Image.network(
                mockEvent.thumbnail,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Icon(Icons.error));
                },
              ),
              maxExtentValue: 280,
              minExtentValue: 80,
            ),
          ),
          SliverToBoxAdapter(
            child: Material(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Text(
                      mockEvent.title,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Column(
                      // properties below title
                      children: mockEvent.properties.entries
                          .map(
                            (entry) => Row(
                              spacing: 6,
                              children: [
                                Icon(getPropertyIcon(entry.key), size: 12),
                                Text(
                                  entry.value,
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                    ExpandableText(
                      allowed: 3,
                      str: // some lorem
                          mockEvent.description,
                    ),
                    const SizedBox(height: 32),
                    Text("Gallery", style: TextStyle(fontSize: 24)),
                    const SizedBox(height: 4),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                      children: mockEvent.pictures
                          .map(
                            (url) => Image.network(
                              url,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(child: Icon(Icons.error));
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ShrinkingImageHeader extends SliverPersistentHeaderDelegate {
  final double maxExtentValue;
  final double minExtentValue;
  final WidgetBuilder imageBuilder;

  const ShrinkingImageHeader({
    required this.imageBuilder,
    required this.maxExtentValue,
    required this.minExtentValue,
  });

  @override
  double get minExtent => minExtentValue;

  @override
  double get maxExtent => maxExtentValue;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Colors.black, // gives smooth collapse background
      child: SizedBox(
        height: (maxExtentValue - shrinkOffset).clamp(
          minExtentValue,
          maxExtentValue,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            imageBuilder(context),
            Positioned(
              right: 16,
              bottom: 16, // put button on corner
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.check),
                label: const Text("Going"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[100],
                  foregroundColor: Colors.black,
                  minimumSize: const Size(110, 42),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant ShrinkingImageHeader oldDelegate) => true;
}
