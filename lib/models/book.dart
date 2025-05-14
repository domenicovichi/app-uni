class Book {
  final String id;
  final String title;
  final String author;
  final String sellerId;
  final double price;
  final String condition; // nuovo, come nuovo, buono, usato
  final String description;
  final List<String> images;
  final String subject;
  final String faculty;
  final bool isAvailable;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.sellerId,
    required this.price,
    required this.condition,
    required this.description,
    required this.images,
    required this.subject,
    required this.faculty,
    this.isAvailable = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'sellerId': sellerId,
      'price': price,
      'condition': condition,
      'description': description,
      'images': images,
      'subject': subject,
      'faculty': faculty,
      'isAvailable': isAvailable,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      sellerId: map['sellerId'],
      price: map['price'].toDouble(),
      condition: map['condition'],
      description: map['description'],
      images: List<String>.from(map['images']),
      subject: map['subject'],
      faculty: map['faculty'],
      isAvailable: map['isAvailable'] ?? true,
    );
  }
}