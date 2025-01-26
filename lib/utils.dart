import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// A utility class that contains common helper functions for validation and UI interactions.
class Utils {
  /// Validates an email address using a regular expression.
  static bool isValidEmail(String email) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
  }

  /// Validates a password by checking if its length is at least 6 characters.
  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  /// Validates a name by checking if its length is at least 2 characters.
  static bool isValidName(String name) {
    return name.length >= 2;
  }

  /// Displays a snackbar with the provided message.
  static showSnackBar(String message, BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    if (scaffoldMessenger.mounted) {
      scaffoldMessenger.hideCurrentSnackBar();
    }

    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// A list of predefined suggestions for the user to choose from.
  static List<List<String>> suggestions = [
    ["summarize", "Summarize text", "0xffd7854f"],
    ["help", "Help me write", "0xffb385bd"],
    ["brain", "Brainstorm", "0xffddc65a"],
    ["surprise", "Surprise Me", "0xff8ccee8"],
  ];
}
