import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/message.dart';

class ChatService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  Stream<List<Map<String, dynamic>>> getUsers() {
    return firestore
        .collection('Users')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Stream<List<Map<String, dynamic>>> searchUsers(String query) {
    return firestore.collection('Users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).where((user) {
        final name = (user['name'] ?? '').toString().toLowerCase();
        final email = (user['email'] ?? '').toString().toLowerCase();
        return name.contains(query.toLowerCase()) ||
            email.contains(query.toLowerCase());
      }).toList();
    });
  }

  Future<void> sendMessage(String receiveId, String message) async {
    final String currUserId = auth.currentUser!.uid;
    final Timestamp timestamp = Timestamp.now();

    final userDoc = await firestore.collection('Users').doc(currUserId).get();
    final senderName =
        (userDoc.exists &&
            (userDoc.data()?['name'] ?? '').toString().trim().isNotEmpty)
        ? userDoc.data()!['name']
        : userDoc.data()?['email'] ?? 'Unknown';

    final newMessage = MessageModel(
      senderId: currUserId,
      senderName: senderName,
      receiverId: receiveId,
      message: message,
      timeStamp: timestamp,
    );

    List<String> ids = [currUserId, receiveId]..sort();
    String chatRoomId = ids.join('_');

    await firestore
        .collection('chatroom')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessage(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId]..sort();
    String chatRoomId = ids.join('_');

    return firestore
        .collection('chatroom')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timeStamp', descending: false)
        .snapshots();
  }

  Future<void> deleteUser(String userId) async {
    try {
      await firestore.collection('Users').doc(userId).delete();
      final chatrooms = await firestore.collection('chatroom').get();
      for (var room in chatrooms.docs) {
        if (room.id.contains(userId)) {
          final messages = await room.reference.collection('messages').get();
          for (var msg in messages.docs) {
            await msg.reference.delete();
          }
          await room.reference.delete();
        }
      }
      print('User and related messages deleted successfully');
    } catch (e) {
      print('Error deleting user: $e');
      rethrow;
    }
  }
}
