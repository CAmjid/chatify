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
        selectedFontSize: 12,
        unselectedFontSize: 11,

        items: [
          BottomNavigationBarItem(
            icon: controller.selectedindex == 0
                ? Icon(Icons.chat_outlined)
                : Icon(Icons.chat_rounded),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: controller.selectedindex == 1
                ? Icon(Icons.add_card_outlined)
                : Icon(Icons.add_circle),
            label: 'Updates',
          ),
          BottomNavigationBarItem(
            icon: controller.selectedindex == 2
                ? Icon(Icons.phone_outlined)
                : Icon(Icons.phone),
            label: 'Calls',
          ),
        ],
      ),
    );
  }
}
