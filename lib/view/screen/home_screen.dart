import 'package:chatify/controller/auth_controller.dart';
import 'package:chatify/controller/chat_controller.dart';
import 'package:chatify/view/screen/chat_screen.dart';
import 'package:chatify/view/screen/login_screen.dart';
import 'package:chatify/view/widget/app_text.dart';
import 'package:chatify/view/widget/user_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController search = TextEditingController();

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatController = context.watch<ChatController>();
    final log = Provider.of<AuthController>(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: AppText(
          name: 'Chatify',
          fontsize: 25,
          fontWeight: FontWeight.bold,
        ),
        elevation: 1,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'settings') {
              } else if (value == 'logout') {
                showLogoutDialog(context, log);
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'settings', child: Text('Settings')),
              PopupMenuItem(
                value: 'logout',
                child: Text('Logout', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.brown, Color.fromARGB(255, 19, 11, 111)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: search,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  hintText: 'Search users...',
                  hintStyle: TextStyle(color: Colors.white70),
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
                onChanged: (value) => chatController.updateSearchQuery(value),
              ),
            ),
          ),
        ),
      ),

      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: chatController.users,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: AppText(name: 'Something went wrong'));
          }
          if (!snapshot.hasData) {
            return const Center(child: AppText(name: 'Loading...'));
          }
          final users = snapshot.data!
              .where((user) => user['uid'] != chatController.currentUserId)
              .toList();
          if (users.isEmpty) {
            return const Center(child: AppText(name: 'No users found'));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final userName = user['name'] ?? user['email'] ?? 'Unknown';

              return UserTile(
                text: userName,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(
                        receiveName: userName,
                        receiveId: user['uid'],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  void showLogoutDialog(BuildContext context, AuthController log) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              log.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
