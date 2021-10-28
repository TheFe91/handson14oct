import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handson14ott/controllers/chat_controller.dart';

final ChatController _chatController = Get.find<ChatController>();

class MessageBubble extends StatelessWidget {
  final String messageId;
  final String message;
  final String username;
  final bool isMe;
  final bool isModerator;

  const MessageBubble(
    this.messageId,
    this.message,
    this.username, {
    Key? key,
    this.isMe = false,
    this.isModerator = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Row bubble = Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text('$username${isModerator ? ' (MODERATOR)' : ''}'),
            Container(
              decoration: BoxDecoration(
                color: isMe ? Colors.black26 : Colors.lightBlue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isMe ? 24 : 5),
                  topRight: Radius.circular(isMe ? 5 : 24),
                  bottomRight: const Radius.circular(24),
                  bottomLeft: const Radius.circular(24),
                ),
              ),
              width: 168,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                message,
                textAlign: isMe ? TextAlign.right : TextAlign.left,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );

    return isModerator
        ? Dismissible(
            direction: DismissDirection.endToStart,
            onDismissed: (direction) =>
                _chatController.removeMessage(messageId),
            key: key!,
            child: bubble,
          )
        : bubble;
  }
}
