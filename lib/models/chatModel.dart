/// A class representing a chat interaction between a user and a GPT assistant.
/// Includes details such as the user message, GPT response, timestamp, and optional metadata.
class Chat {
  String? gpt;
  String user;
  DateTime timestamp;
  String? convId;
  String? userId;
  String model;
  List<String>? urls;

  /// Constructor to initialize a Chat instance.
  Chat(
      {this.gpt,
      required this.user,
      required this.timestamp,
      this.convId,
      this.userId,
      required this.model,
      this.urls});

  /// Creates a Chat instance from a JSON object.
  Chat.fromJson(Map<String, dynamic> json)
      : gpt = json['gpt'] ?? '',
        user = json['user'] ?? '',
        timestamp = json['timestamp'] ?? '',
        convId = json['convId'] ?? '',
        userId = json['userId'] ?? '',
        model = json['model'] ?? '',
        urls =
            (json['urls'] as List<dynamic>?)?.map((e) => e.toString()).toList();

  /// Converts the Chat instance to a JSON object.
  Map<String, dynamic> toJson() {
    return {
      'gpt': gpt,
      'user': user,
      'timestamp': timestamp,
      'convId': convId,
      'userId': userId,
      'model': model,
      'urls': urls,
    };
  }
}
