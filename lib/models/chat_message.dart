import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String id;
  final String username;
  final String message;
  final bool isModerator;
  final DateTime createdAt;

  ChatMessage(
      this.id, this.username, this.message, this.isModerator, this.createdAt);

  ChatMessage.fromJson(this.id, Map json)
      : username = json['username'],
        message = json['message'],
        isModerator = json['isModerator'],
        createdAt = (json['createdAt'] as Timestamp).toDate();
}
