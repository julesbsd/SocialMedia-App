class User {
  String? name;
  String email;
  String profileImage;
  List<String> posts;
  List<Conversation> conversations;  // Change to a list of Conversation objects

  User({
    required this.name,
    required this.email,
    required this.profileImage,
    required this.posts,
    required this.conversations,
  });

  // Fonction pour convertir un User en JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'profileImage': profileImage,
      'posts': posts,
      'conversations': conversations.map((c) => c.toJson()).toList(),
    };
  }

  // Fonction pour créer un User à partir d'un JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      profileImage: json['profileImage'] ?? '',
      posts: List<String>.from(json['posts'] ?? []),
      conversations: (json['conversations'] != null)
          ? (json['conversations'] as List)
              .map((conv) => Conversation.fromJson(conv))
              .toList()
          : [],
    );
  }
}

class Conversation {
  String id;
  List<Participant> participants;
  List<Message> messages;
  DateTime createdAt;

  Conversation({
    required this.id,
    required this.participants,
    required this.messages,
    required this.createdAt,
  });

  // Fonction pour convertir une Conversation en JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'participants': participants.map((p) => p.toJson()).toList(),
      'messages': messages.map((m) => m.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Fonction pour créer une Conversation à partir d'un JSON
  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['_id'],
      participants: (json['participants'] as List)
          .map((p) => Participant.fromJson(p))
          .toList(),
      messages: (json['messages'] as List)
          .map((m) => Message.fromJson(m))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class Participant {
  String id;
  String name;

  Participant({
    required this.id,
    required this.name,
  });

  // Fonction pour convertir un Participant en JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
    };
  }

  // Fonction pour créer un Participant à partir d'un JSON
  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      id: json['_id'],
      name: json['name'],
    );
  }
}

class Message {
  String id;
  String author;
  String content;
  DateTime createdAt;

  Message({
    required this.id,
    required this.author,
    required this.content,
    required this.createdAt,
  });

  // Fonction pour convertir un Message en JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'author': author,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Fonction pour créer un Message à partir d'un JSON
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['_id'],
      author: json['author'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
