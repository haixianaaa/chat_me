import 'chat_message.dart';

class ChatSession {
  final String id;
  final String characterId;
  final String characterName;
  final String characterAvatar;
  final List<ChatMessage> messages;
  final DateTime createdAt;
  DateTime updatedAt;

  ChatSession({
    required this.id,
    required this.characterId,
    required this.characterName,
    required this.characterAvatar,
    List<ChatMessage>? messages,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : messages = messages ?? [],
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  String get lastMessage =>
      messages.isNotEmpty ? messages.last.content : '';

  Map<String, dynamic> toJson() => {
        'id': id,
        'characterId': characterId,
        'characterName': characterName,
        'characterAvatar': characterAvatar,
        'messages': messages.map((m) => m.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory ChatSession.fromJson(Map<String, dynamic> json) => ChatSession(
        id: json['id'] as String,
        characterId: json['characterId'] as String,
        characterName: json['characterName'] as String,
        characterAvatar: json['characterAvatar'] as String,
        messages: (json['messages'] as List)
            .map((m) => ChatMessage.fromJson(m as Map<String, dynamic>))
            .toList(),
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );
}
