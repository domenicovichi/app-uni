class Event {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final String organizerId;
  final List<String> participants;
  final String? imageUrl;
  final String eventType; // academic, social, cultural, etc.

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.organizerId,
    required this.participants,
    this.imageUrl,
    required this.eventType,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'location': location,
      'organizerId': organizerId,
      'participants': participants,
      'imageUrl': imageUrl,
      'eventType': eventType,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      date: DateTime.parse(map['date']),
      location: map['location'],
      organizerId: map['organizerId'],
      participants: List<String>.from(map['participants']),
      imageUrl: map['imageUrl'],
      eventType: map['eventType'],
    );
  }
}