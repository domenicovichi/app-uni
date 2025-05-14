class User {
  final String id;
  final String email;
  final String username;
  final String university;
  final String faculty;
  final String? profileImageUrl;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.university,
    required this.faculty,
    this.profileImageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'university': university,
      'faculty': faculty,
      'profileImageUrl': profileImageUrl,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      username: map['username'],
      university: map['university'],
      faculty: map['faculty'],
      profileImageUrl: map['profileImageUrl'],
    );
  }
}