import 'package:chatify/controller/chat_controller.dart';
import 'package:chatify/view/widget/chat_bubble.dart';
import 'package:chatify/view/widget/app_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget {
  final String receiveName;
  final String receiveId;

  ChatScreen({super.key, required this.receiveName, required this.receiveId});

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final chat = context.read<ChatController>();

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 70,
        leading: const BackButton(),
        title: AppText(name: receiveName, color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.brown, Color.fromARGB(255, 19, 11, 111)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(child: messageList(context)),
          input(chat),
        ],
      ),
    );
  }

  Widget messageList(BuildContext context) {
    return Consumer<ChatController>(
      builder: (context, chat, _) {
        return StreamBuilder<QuerySnapshot>(
          stream: chat.messages(receiveId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: AppText(name: 'Loading...'));
            }
            final messages = snapshot.data!.docs;

            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final data = messages[index].data() as Map<String, dynamic>;
                final isMe = data['senderId'] == chat.currentUserId;
                return Align(
                  alignment: isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: ChatBubble(
                    message: data['message'],
                    currentUser: isMe,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget input(ChatController chat) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Type a message',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.green, Colors.teal],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.send,
                color: Color.fromARGB(255, 46, 20, 151),
              ),
              onPressed: () async {
                if (controller.text.trim().isEmpty) return;
                await chat.send(receiveId, controller.text);
                controller.clear();
              },
            ),
          ),
        ],
      ),
    );
  }
}
