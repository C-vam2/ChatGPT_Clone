import 'dart:math';

import 'package:chatgpt/database/database.dart';
import 'package:chatgpt/models/conversationModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../models/chatModel.dart';

/// Provider for managing chat-related data and operations

class ChatProvider extends ChangeNotifier {
  List<Chat> chats = []; // List of Chat objects representing current chats
  String currConversationId = ""; // Current conversation ID

  /// Adds a new chat to the list and notifies listeners
  void addChat(Chat chat) {
    chats.add(chat);
    notifyListeners();
  }

  /// Sets the current conversation ID and notifies listeners
  void setConvId(String convId) {
    currConversationId = convId;
    notifyListeners();
  }

  /// Creates a new chat or updates an existing one in the database
  ///
  /// - If there are chats and the user is authenticated:
  ///   - If `currConversationId` is empty, a new conversation is created.
  ///   - Otherwise, updates the existing conversation in the database.
  /// - After database operations, clears the current chats and resets the state.
  ///
  /// Returns:
  /// - `"success"` if the operation is successful.
  /// - An error message if the database operation fails.

  Future<String> newChat(String userId) async {
    if (chats.isNotEmpty && (FirebaseAuth.instance.currentUser != null)) {
      if (currConversationId == "") {
        print('b');
        var rng = Random();
        String convId =
            "${DateTime.now().millisecondsSinceEpoch}${rng.nextDouble()}";
        ConversationModel conv = ConversationModel(
          convId: convId,
          title: chats[0].user,
          userId: userId,
          timestamp: DateTime.now(),
          chats: chats,
        );
        final res = await MongoDB.insertChat(conv);
        if (res != "success") {
          return res;
        }
      } else {
        print('c');
        final res = await MongoDB.updateChat(chats, currConversationId);

        print(res);
        if (res != "success") {
          return res;
        }
        currConversationId = "";
      }
    }
    print('d');
    chats.clear();
    notifyListeners();
    return "New Chat Initialized";
  }

  /// Sets the current list of chats and notifies listeners
  void setChat(List<Chat> newChat) {
    chats = newChat;
    notifyListeners();
  }
}
