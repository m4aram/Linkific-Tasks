import 'package:flutter/material.dart';

class AnswerButton extends StatelessWidget {
  final String text;
  final bool selected;
  final bool correct;
  final bool showResult;
  final VoidCallback onPressed;

  const AnswerButton({
    super.key,
    required this.text,
    required this.selected,
    required this.correct,
    required this.showResult,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    Color backgroundColor;

    if (showResult && correct) {
      backgroundColor = colors.primaryContainer;
    } else if (showResult && selected && !correct) {
      backgroundColor = colors.errorContainer;
    } else if (selected) {
      backgroundColor = colors.secondaryContainer;
    } else {
      backgroundColor = colors.surfaceContainerHighest;
    }

    return SizedBox(
      width: double.infinity,
      child: Card(
        color: backgroundColor,
        child: ListTile(
          title: Text(text),
          onTap: showResult ? null : onPressed,
          trailing: selected
              ? Icon(
                  showResult && correct
                      ? Icons.check_circle
                      : Icons.radio_button_checked,
                )
              : const Icon(Icons.radio_button_unchecked),
        ),
      ),
    );
  }
}
