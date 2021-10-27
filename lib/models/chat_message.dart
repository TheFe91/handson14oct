import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String id;
  final String username;
  final String message;
  final DateTime createdAt;

  ChatMessage(this.id, this.username, this.message, this.createdAt);

  ChatMessage.fromJson(this.id, Map json)
      : username = json['username'],
        message = json['message'],
        createdAt = (json['createdAt'] as Timestamp).toDate();
}
