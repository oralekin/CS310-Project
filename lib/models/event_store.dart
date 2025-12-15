class EventModel {
  final String title;
  final String category;
  final DateTime date;
  final String time;
  final String location;
  final String description;

  EventModel({
    required this.title,
    required this.category,
    required this.date,
    required this.time,
    required this.location,
    required this.description,
  });

  // ✅ Equality override (çok önemli)
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EventModel &&
        other.title == title &&
        other.date == date &&
        other.time == time &&
        other.location == location;
  }

  @override
  int get hashCode {
    return title.hashCode ^
    date.hashCode ^
    time.hashCode ^
    location.hashCode;
  }
}

// Global mock event store
List<EventModel> globalEvents = [];
List<EventModel> myEvents = [];
