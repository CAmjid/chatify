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
    final chat = Provider.of<ChatController>(context);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 239, 235, 235),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.phone_outlined, size: 20),
          ),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert, size: 20)),
        ],
        leading: const BackButton(),
        title: Row(
          children: [
            CircleAvatar(
              child: AppText(
                name: receiveName[0].toUpperCase(),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 10),
            AppText(name: receiveName),
          ],
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
                final load = data['senderId'] == chat.currentUserId;
                return Align(
                  alignment: load
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: ChatBubble(
                    message: data['message'],
                    currentUser: load,
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
