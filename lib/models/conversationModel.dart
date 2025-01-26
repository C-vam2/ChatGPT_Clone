import 'chatModel.dart';

/// Represents a conversation, including metadata and a list of chat messages.
class ConversationModel {
  String convId;
  String title;
  String userId;
  DateTime timestamp;
  List<Chat> chats;

  /// Constructor to initialize a ConversationModel instance.
  ConversationModel({
    required this.convId,
    required this.title,
    required this.userId,
    required this.timestamp,
    this.chats = const [],
  });

  /// Creates a ConversationModel instance from a JSON object.
  ConversationModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        userId = json['userId'],
        timestamp = json['timestamp'],
        convId = json['convId'],
        chats = (json['chats'] as List<dynamic>?)
                ?.map((chat) => Chat.fromJson(chat))
                .toList() ??
            [];

  /// Converts the ConversationModel instance to a JSON object.

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'userId': userId,
      'convId': convId,
      'timestamp': timestamp,
      'chats': chats.map((chat) => chat.toJson()).toList(),
    };
  }
}
