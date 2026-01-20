import 'package:chatify/service/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatController extends ChangeNotifier {
  final ChatService _chatService = ChatService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _searchQuery = '';

  String get currentUserId => _auth.currentUser!.uid;

  void updateSearchQuery(String query) {
    _searchQuery = query.trim();
    notifyListeners();
  }

  Stream<List<Map<String, dynamic>>> get users {
    if (_searchQuery.isEmpty) {
      return _chatService.getUsers();
    } else {
      return _chatService.searchUsers(_searchQuery);
    }
  }

  Stream<QuerySnapshot> messages(String otherUserId) {
    return _chatService.getMessage(currentUserId, otherUserId);
  }

  Future<void> send(String receiverId, String message) async {
    if (message.trim().isEmpty) return;
    await _chatService.sendMessage(receiverId, message);
  }
}
