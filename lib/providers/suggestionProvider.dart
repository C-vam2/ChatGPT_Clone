import 'package:flutter/material.dart';

/// Provider for managing the current suggestion
class SuggestionProvider extends ChangeNotifier {
  String currSuggestion = "";

  /// Changes the current suggestion and notifies listeners
  ///
  /// [suggestion]: The new suggestion string to set.
  void changeSuggestion(String suggestion) {
    currSuggestion = suggestion;
    notifyListeners();
  }
}
