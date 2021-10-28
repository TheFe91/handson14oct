import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handson14ott/models/chat_message.dart';

class ChatController extends GetxController {
  final RxList<ChatMessage> chatMessages = RxList<ChatMessage>();
  final RxBool isConnectingToFirestore = false.obs;

  @override
  void onInit() {
    chatMessages.bindStream(getMessages());
    super.onInit();
  }

  Stream<List<ChatMessage>> getMessages() {
    try {
      isConnectingToFirestore(true);

      final stream = FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots();

      return stream.map(
        (qSShot) => qSShot.docs
            .map(
              (doc) => ChatMessage.fromJson(doc.id, doc.data()),
            )
            .toList(),
      );
    } catch (e) {
      rethrow;
    } finally {
      isConnectingToFirestore(false);
    }
  }

  Future<void> sendMessage(
    String username,
    bool isModerator,
    FocusNode textFocusNode,
    TextEditingController controller,
  ) async {
    textFocusNode.requestFocus();
    await FirebaseFirestore.instance.collection('chat').add({
      'message': controller.text,
      'createdAt': Timestamp.now(),
      'username': username,
      'isModerator': isModerator,
    });
    controller.text = '';
  }

  Future<void> removeMessage(String messageId) async {
    await FirebaseFirestore.instance.collection('chat').doc(messageId).delete();
  }
}
