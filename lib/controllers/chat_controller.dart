import 'package:cloud_firestore/cloud_firestore.dart';
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

  void removeMessage(String messageId) {
    chatMessages.removeWhere((chatMessage) => chatMessage.id == messageId);
  }
}
