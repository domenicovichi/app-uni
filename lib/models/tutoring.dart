class Tutoring {
  final String id;
  final String tutorId;
  final String subject;
  final String description;
  final double pricePerHour;
  final List<String> availability; // giorni/orari disponibili
  final String faculty;
  final bool isOnline;
  final bool isInPerson;
  final List<String> reviews;
  final double rating;

  Tutoring({
    required this.id,
    required this.tutorId,
    required this.subject,
    required this.description,
    required this.pricePerHour,
    required this.availability,
    required this.faculty,
    required this.isOnline,
    required this.isInPerson,
    this.reviews = const [],
    this.rating = 0.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tutorId': tutorId,
      'subject': subject,
      'description': description,
      'pricePerHour': pricePerHour,
      'availability': availability,
      'faculty': faculty,
      'isOnline': isOnline,
      'isInPerson': isInPerson,
      'reviews': reviews,
      'rating': rating,
    };
  }

  factory Tutoring.fromMap(Map<String, dynamic> map) {
    return Tutoring(
      id: map['id'],
      tutorId: map['tutorId'],
      subject: map['subject'],
      description: map['description'],
      pricePerHour: map['pricePerHour'].toDouble(),
      availability: List<String>.from(map['availability']),
      faculty: map['faculty'],
      isOnline: map['isOnline'],
      isInPerson: map['isInPerson'],
      reviews: List<String>.from(map['reviews']),
      rating: map['rating'].toDouble(),
    );
  }
}