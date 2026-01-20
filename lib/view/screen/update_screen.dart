import 'package:chatify/view/widget/app_text.dart';
import 'package:flutter/material.dart';

class UpdateScreen extends StatelessWidget {
  const UpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(name: 'Updates'),
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
      body: ListView(
        children: [
          ListTile(
            leading: Stack(
              children: [
                const CircleAvatar(radius: 25),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
            title: AppText(name: 'My Status'),
            subtitle: AppText(name: 'Tap to add status update'),
            onTap: () {},
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AppText(
              name: 'Recent Updates',
              fontsize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          ListTile(
            leading: const CircleAvatar(
              radius: 25,
              child: AppText(
                name: 'A',
                fontsize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            title: const Text('Amjid'),
            subtitle: const Text('Today, 10:45 AM'),
            onTap: () {},
          ),
          ListTile(
            leading: const CircleAvatar(
              radius: 25,
              child: AppText(
                name: 'S',
                fontsize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            title: const Text('Sahil'),
            subtitle: const Text('Today, 9:30 AM'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
