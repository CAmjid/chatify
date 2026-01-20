import 'package:chatify/controller/controller.dart';
import 'package:chatify/view/screen/call_screen.dart';
import 'package:chatify/view/screen/home_screen.dart';
import 'package:chatify/view/screen/update_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottombarScreen extends StatefulWidget {
  const BottombarScreen({super.key});

  @override
  State<BottombarScreen> createState() => _BottombarScreenState();
}

class _BottombarScreenState extends State<BottombarScreen> {
  final List<Widget> pages = [HomeScreen(), UpdateScreen(), CallsScreen()];

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<Controller>(context);
    return Scaffold(
      body: pages[controller.selectedindex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: controller.selectedindex,
        onTap: (index) {
          controller.changeData(index);
        },
        selectedItemColor: const Color.fromARGB(255, 38, 20, 142),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_rounded),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'Updates',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.phone), label: 'Calls'),
        ],
      ),
    );
  }
}
