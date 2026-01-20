import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String senderId;
  final String senderName;
  final String receiverId;
  final String message;
  final Timestamp timeStamp;

  MessageModel({
    required this.senderId,
    required this.senderName,
    required this.receiverId,
    required this.message,
    required this.timeStamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderName': senderName,
      'receiverId': receiverId,
      'message': message,
      'timeStamp': timeStamp,
    };
  }
}
