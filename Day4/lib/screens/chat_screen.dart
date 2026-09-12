import 'package:flutter/material.dart';
class ChatScreen extends StatelessWidget
{ const ChatScreen({super.key});
@override Widget build(BuildContext context)
{ final messages = List.generate( 120, (index) => 'Message ${index + 1}', );
return Scaffold(
  appBar: AppBar(
    title: const Text('WhatsApp Chat'),
    centerTitle: true,
  ),
  body: ListView.builder(
    physics: const BouncingScrollPhysics(),
    padding: const EdgeInsets.all(12),
    itemCount: messages.length,
    itemBuilder: (context, index) {
      final isMe = index.isEven;

      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          mainAxisAlignment:
          isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: isMe
                      ? Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      : Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest,
                ),
                child: Text(messages[index]),
              ),
            ),
          ],
        ),
      );
    },
  ),
);
} }