import 'package:chatify/view/widget/app_text.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool currentUser;
  final String? senderName;

  const ChatBubble({
    super.key,
    required this.message,
    required this.currentUser,
    this.senderName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.75,
      ),
      decoration: BoxDecoration(
        color: currentUser
            ? const Color.fromARGB(255, 220, 248, 198)
            : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16),
          topRight: const Radius.circular(16),
          bottomLeft: currentUser ? const Radius.circular(16) : Radius.zero,
          bottomRight: currentUser ? Radius.zero : const Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: currentUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          if (senderName != null)
            AppText(
              name: senderName!,
              fontWeight: FontWeight.bold,
              fontsize: 13,
              color: Colors.grey.shade700,
            ),

          if (senderName != null) const SizedBox(height: 4),

          AppText(name: message, fontsize: 15),
        ],
      ),
    );
  }
}

