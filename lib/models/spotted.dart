class Spotted {
  final String id;
  final String text;
  final String authorId;
  final DateTime createdAt;
  final List<String> likes;
  final List<String> comments;
  final bool isAnonymous;

  Spotted({
    required this.id,
    required this.text,
    required this.authorId,
    required this.createdAt,
    required this.likes,
    required this.comments,
    this.isAnonymous = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'authorId': authorId,
      'createdAt': createdAt.toIso8601String(),
      'likes': likes,
      'comments': comments,
      'isAnonymous': isAnonymous,
    };
  }

  factory Spotted.fromMap(Map<String, dynamic> map) {
    return Spotted(
      id: map['id'],
      text: map['text'],
      authorId: map['authorId'],
      createdAt: DateTime.parse(map['createdAt']),
      likes: List<String>.from(map['likes']),
      comments: List<String>.from(map['comments']),
      isAnonymous: map['isAnonymous'] ?? true,
    );
  }
}