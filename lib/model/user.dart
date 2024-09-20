import 'dart:convert';

class User {
  String ?name;
  String email;
  String? profileImage;
  List<String> ?posts;

  User({
    required this.name,
    required this.email,
    this.profileImage,
    this.posts = const [],
  });

  // Fonction pour convertir un User en JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'profileImage': profileImage,
      'posts': posts,
    };
  }

  // Fonction pour créer un User à partir d'un JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      profileImage: json['profileImage'],
      posts: List<String>.from(json['posts'] ?? []),
    );
  }
}
