import 'package:chatgpt/widgets/suggestionCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/suggestionProvider.dart';
import '../utils.dart';

/// A widget that displays the homepage with suggestion cards to guide the user.
class IntroHomepage extends StatelessWidget {
  const IntroHomepage({
    super.key,
    required TextEditingController textEditingController,
  }) : _textEditingController = textEditingController;

  final TextEditingController _textEditingController;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "What can I help with?",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16), // Add spacing between the text and cards
          Consumer<SuggestionProvider>(
              builder: (context, value, child) => Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8, // Horizontal space between cards
                    runSpacing: 8, // Vertical space between rows of cards
                    children: Utils.suggestions
                        .map((e) => GestureDetector(
                              onTap: () {
                                value.currSuggestion = e[1];
                                _textEditingController.text = e[1];
                              },
                              child: SuggestionCard(
                                icon: e[0],
                                title: e[1],
                                color: e[2],
                              ),
                            ))
                        .toList(),
                  )),
        ],
      ),
    );
  }
}
