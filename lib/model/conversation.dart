import 'dart:convert';

class Conversation {
  int id;
  List<dynamic> participants;
  DateTime created_at;
  final List<Message> messages;

  Conversation({
    required this.id,
    required this.participants,
    required this.created_at,
    required this.messages,
  });

// Fonction pour convertir un User en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'participants': participants,
      'created_at': created_at,
      "messages": messages,
    };
  }

//Créer une conversation à partir d'un JSON
  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      participants: List<dynamic>.from(json['participants'] ?? []),
      created_at: DateTime.parse(json['created_at']),
      messages: List<Message>.from(
          json['messages'].map((x) => Message.fromJson(x)) ?? []),
    );
  }
}

class Message {
  final int id;
  final String? content;
  final DateTime? createdAt;
  final String conversationId;

  Message({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.conversationId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'created_at': createdAt,
      'conversationId': conversationId,
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
      conversationId: json['conversationId'],
    );
  }
}
