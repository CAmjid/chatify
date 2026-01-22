import 'package:chatify/view/widget/app_text.dart';
import 'package:flutter/material.dart';

class CallsScreen extends StatelessWidget {
  const CallsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final calls = [
      {'name': 'Alice', 'type': 'incoming', 'time': 'Today, 10:00 AM'},
      {'name': 'Bob', 'type': 'outgoing', 'time': 'Yesterday, 5:30 PM'},
    ];

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 70,

        title: AppText(name: 'Call', fontsize: 20, fontWeight: FontWeight.bold),
      ),
      body: ListView.builder(
        itemCount: calls.length,
        itemBuilder: (context, index) {
          final call = calls[index];
          return ListTile(
            leading: CircleAvatar(child: Text(call['name']![0])),
            title: AppText(name: call['name']!),
            subtitle: AppText(name: call['time']!),
            trailing: Icon(Icons.call_made, color: Colors.green),
            onTap: () {},
          );
        },
      ),
    );
  }
}
