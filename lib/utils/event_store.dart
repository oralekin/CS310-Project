  class EventModel {
  final String title;
  final String description;
  final String category;
  final String date;
  final String time;
  final String location;

  EventModel({
    required this.title,
    required this.description,
    required this.category,
    required this.date,
    required this.time,
    required this.location,
  });
}


List<EventModel> globalEvents = [
  EventModel(
    title: "Campus Yoga Session",
    description: "Relaxing yoga event for all levels.",
    category: "Sports",
    date: "25/11/2025",
    time: "10:00",
    location: "SU Sport Center",
  ),
  EventModel(
    title: "AI Workshop",
    description: "Hands-on workshop for AI beginners.",
    category: "Workshop",
    date: "28/11/2025",
    time: "14:00",
    location: "FENS G077",
  ),
  EventModel(
    title: "Music Night",
    description: "Live music event organized by SU Music Club.",
    category: "Social",
    date: "30/11/2025",
    time: "19:30",
    location: "Hangar",
  ),
];


List<EventModel> myEvents = [];
