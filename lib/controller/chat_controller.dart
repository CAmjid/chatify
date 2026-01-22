import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../service/chat_service.dart';

class ChatController extends ChangeNotifier {
  final ChatService chatService = ChatService();
  final FirebaseAuth auth = FirebaseAuth.instance;

  String searchQuery = '';

  String? get currentUserId => auth.currentUser?.uid;

  void updateSearchQuery(String query) {
    searchQuery = query.trim();
    notifyListeners();
  }

  Stream<List<Map<String, dynamic>>> get users {
    if (searchQuery.isEmpty) {
      return chatService.getUsers();
    } else {
      return chatService.searchUsers(searchQuery);
    }
  }

  Stream<QuerySnapshot> messages(String otherUserId) {
    final uid = currentUserId;
    if (uid == null) {
      return const Stream.empty();
    }
    return chatService.getMessage(uid, otherUserId);
  }

  Future<void> send(String receiverId, String message) async {
    if (message.trim().isEmpty) return;
    await chatService.sendMessage(receiverId, message);
  }

  Future<void> deleteUser(String userId) async {
    try {
      await chatService.deleteUser(userId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting user: $e');
      rethrow;
    }
  }
}
