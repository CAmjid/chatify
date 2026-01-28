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
    final chatController = Provider.of<ChatController>(context);
    final log = Provider.of<AuthController>(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: AppText(
          name: 'Chatify',
          fontsize: 25,
          fontWeight: FontWeight.bold,
          color: const Color.fromARGB(255, 24, 108, 156),
        ),
        elevation: 1,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.qr_code_scanner, size: 20),
          ),
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 220, 216, 216),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: search,

                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Search users...',
                  hintStyle: TextStyle(color: Colors.black),
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
              final userName =
                  (user['name'] != null &&
                      user['name'].toString().trim().isNotEmpty)
                  ? user['name']
                  : user['email'];
              return UserTile(
                name: userName[0],
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
                onLongPress: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Delete user?'),
                      content: Text(
                        'Are you sure you want to delete $userName?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    await context.read<ChatController>().deleteUser(
                      user['uid'],
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('$userName deleted')),
                    );
                  }
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
      barrierDismissible: false,
      builder: (Context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(Context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(Context);
                await log.logout();

                if (!context.mounted) return;

                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
