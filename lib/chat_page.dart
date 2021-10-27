import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handson14ott/controllers/chat_controller.dart';
import 'package:handson14ott/message_bubble.dart';

final TextEditingController _controller = TextEditingController();

class ChatPage extends StatelessWidget {
  final String name;
  final String surname;

  const ChatPage({
    required this.name,
    required this.surname,
    Key? key,
  }) : super(key: key);

  Future<void> _sendMessage(context, message) async {
    FocusScope.of(context).unfocus();
    await FirebaseFirestore.instance.collection('chat').add({
      'message': message,
      'createdAt': Timestamp.now(),
      'username': '$name $surname',
    });
    _controller.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        width: Get.width,
        height: Get.height,
        child: Column(
          children: [
            GetX<ChatController>(
              init: ChatController(),
              builder: (cValues) => Expanded(
                child: cValues.isConnectingToFirestore.value
                    ? const CircularProgressIndicator.adaptive()
                    : ListView.builder(
                        reverse: true,
                        itemCount: cValues.chatMessages.length,
                        itemBuilder: (__, i) => Container(
                          padding: const EdgeInsets.all(8),
                          child: MessageBubble(
                            cValues.chatMessages[i].id,
                            cValues.chatMessages[i].message,
                            cValues.chatMessages[i].username,
                            isMe: cValues.chatMessages[i].username ==
                                '$name $surname',
                            key: ValueKey(cValues.chatMessages[i].id),
                          ),
                        ),
                      ),
              ),
            ),
            TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Type a message',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _sendMessage(context, _controller.text),
                ),
              ),
              onFieldSubmitted: (_) => _sendMessage(context, _controller.text),
            )
          ],
        ),
      ),
    );
  }
}
