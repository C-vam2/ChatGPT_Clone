import 'dart:convert';

import 'package:chatgpt/models/imageModel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  /// Sends a request to the OpenAI API for a text-based response
  ///
  /// [message]: The user input message for the model.
  /// [modelId]: The ID of the model to use for the completion (e.g., 'gpt-3.5-turbo').
  /// Returns the response content from the OpenAI API.
  static Future<String> getResponse(String message, String modelId) async {
    try {
      final response = await http.post(
        Uri.parse("https://api.openai.com/v1/chat/completions"),
        headers: {
          "Authorization": "Bearer ${dotenv.env['API_KEY']}",
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "model": modelId, // Specify the model here
          "messages": [
            {
              "role": "user",
              "content": message,
            }
          ],
          "temperature": 0.7, // Include temperature at the same level
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        // print("This is response:==> " + jsonResponse.toString());
        if (jsonResponse['choices'].length > 0) {
          return jsonResponse['choices'][0]['message']
              ['content']; // Correctly access the content
        }
        return "No choices available";
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
        return "Error: ${response.statusCode}";
      }
    } catch (err) {
      print("Exception: $err");
      return "error";
    }
  }

  /// Sends a request to the OpenAI API for a response with text and image URLs
  ///
  /// [message]: The user input message for the model.
  /// [images]: A list of image models containing the URLs of images.
  /// Returns the response content from the OpenAI API.
  static Future<String> getVisionResponse(
      String message, List<ImageModel> images) async {
    try {
      final bodyContents = [];
      bodyContents.add(
        {"type": "text", "text": message},
      );
      for (int i = 0; i < images.length; i++) {
        bodyContents.add(
          {
            "type": "image_url",
            "image_url": {"url": images[i].url}
          },
        );
      }

      final response = await http.post(
        Uri.parse("https://api.openai.com/v1/chat/completions"),
        headers: {
          "Authorization": "Bearer ${dotenv.env['API_KEY']}",
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "model": "gpt-4-turbo-2024-04-09", // Specify the model here
          "messages": [
            {
              "role": "user",
              "content": bodyContents,
            }
          ],
          "temperature": 0.7, // Include temperature at the same level
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse['choices'].length > 0) {
          return jsonResponse['choices'][0]['message']['content'];
        }
        return "No choices available";
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
        return "Error: ${response.statusCode}";
      }
    } catch (err) {
      print("Exception: $err");
      return "error";
    }
  }
}
