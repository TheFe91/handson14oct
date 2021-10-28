import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:handson14ott/controllers/auth_controller.dart';
import 'package:handson14ott/controllers/chat_controller.dart';
import 'package:handson14ott/main.dart';
import 'package:handson14ott/message_bubble.dart';

final TextEditingController _controller = TextEditingController();
final AuthController _authController = Get.find<AuthController>();
final ChatController _chatController = Get.find<ChatController>();
final FocusNode _textFocusNode = FocusNode();

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  void _onBackButtonPressed() {
    GetStorage().erase();
    _authController.erase();
    Get.off(() => const HandsOn());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CHAT${_authController.isModerator ? ' - MODERATOR' : ''}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _onBackButtonPressed,
        ),
      ),
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
                                '${_authController.name} ${_authController.surname}',
                            isModerator: cValues.chatMessages[i].isModerator,
                            key: ValueKey(cValues.chatMessages[i].id),
                          ),
                        ),
                      ),
              ),
            ),
            TextFormField(
              focusNode: _textFocusNode,
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Type a message',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _chatController.sendMessage(
                    '${_authController.name} ${_authController.surname}',
                    _authController.isModerator,
                    _textFocusNode,
                    _controller,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
