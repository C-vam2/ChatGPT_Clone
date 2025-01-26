import 'dart:developer';

import 'package:chatgpt/models/conversationModel.dart';
import 'package:chatgpt/models/userModel.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/chatModel.dart';

///This class handles all the functionalities related to interacting to database of our app.

class MongoDB {
  static Db? db;
  static DbCollection? userCollection;
  static DbCollection? chatCollection;

  ///Connect to MongoDB
  static Future<void> connect() async {
    try {
      db = await Db.create(dotenv.env['DATABASE_URL'] ?? "");

      await db!.open();
      inspect(db);

      var status = await db!.serverStatus();
      print('Server Status----> $status');

      userCollection = db!.collection(dotenv.env['USER_COLLECTION'] ?? "");
      chatCollection = db!.collection(dotenv.env['CHAT_COLLECTION'] ?? "");
      print(
          'Connected to MongoDB and userCollection  AND chatCollection initialized');
    } catch (e) {
      print("Error connecting to MongoDB: $e");
    }
  }

  ///Insert data into MongoDB userCollection
  static Future<String> insertUser(UserModel data) async {
    if (db == null || !db!.isConnected) {
      return "Database is not connected";
    }
    if (userCollection == null) {
      return 'User collection is not initialized. Ensure connect() is called.';
    }

    try {
      var response = await userCollection!.insertOne(data.toJson());
      return response.isSuccess ? "Inserted Successfully" : "Insert Failed";
    } catch (e) {
      print("Error When Inserting Data: $e");
      return "Failed to insert data: ${e.toString()}";
    }
  }

  ///Insert data into MongoDB chatCollection
  static Future<String> insertChat(ConversationModel data) async {
    if (db == null || !db!.isConnected) {
      return "Database is not connected";
    }
    if (chatCollection == null) {
      return 'Chat collection is not initialized. Ensure connect() is called';
    }

    try {
      var response = await chatCollection!.insertOne(data.toJson());
      return response.isSuccess ? "success" : "Insert failed";
    } catch (e) {
      print("Error while inserting conversation Data: $e");
      return "Failed to insert data: ${e.toString()}";
    }
  }

  /// Update data for a given conversation ID
  static Future<String> updateChat(List<Chat> chats, String convId) async {
    if (db == null || !db!.isConnected) {
      return "Database is not connected";
    }
    if (chatCollection == null) {
      return 'Chat collection is not initialized. Ensure connect() is called';
    }
    if (chats.isEmpty) {
      return "Chats list is empty. Provide valid data to update.";
    }

    try {
      List<Map<String, dynamic>> chatJson =
          chats.map((chat) => chat.toJson()).toList();

      var response = await chatCollection!.updateOne(
        {"convId": convId},
        {
          '\$set': {
            "chats": chatJson,
          },
        },
      );

      return "success";
    } catch (e) {
      print("Error while updating conversation data: $e");
      return "Failed to update data: ${e.toString()}";
    }
  }

  /// Get conversation data for a given user ID
  static Future<List<ConversationModel>> getConversations(String userId) async {
    if (db == null || !db!.isConnected) {
      throw Exception("Database is not connected");
    }
    if (chatCollection == null) {
      throw Exception(
          'Chat collection is not initialized. Ensure connect() is called');
    }
    try {
      final cursor = chatCollection!.find({"userId": userId});
      final conversations = await cursor.toList();
      List<ConversationModel> res =
          conversations.map((e) => ConversationModel.fromJson(e)).toList();
      return res;
    } catch (e) {
      print("Error while fetching conversation data: $e");
      throw Exception("Failed to fetch conversation data: ${e.toString()}");
    }
  }
}
