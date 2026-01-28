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

    const green = Color.fromARGB(255, 46, 20, 151);

    Widget navIcon(IconData icon, int index) {
      final isSelected = controller.selectedindex == index;

      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? green.withOpacity(0.18) : Colors.transparent,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          
          icon, color: isSelected ? green : Colors.grey.shade500),
      );
    }

    return Scaffold(
      body: pages[controller.selectedindex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: controller.selectedindex,
        onTap: controller.changeData,
        selectedFontSize: 12,
        unselectedFontSize: 11,

        items: [
          BottomNavigationBarItem(
            icon: navIcon(
              Icons.chat_outlined, 0),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: navIcon(Icons.update_outlined, 1),
            label: 'Updates',
          ),
          BottomNavigationBarItem(
            icon: navIcon(Icons.phone_outlined, 2),
            label: 'Calls',
          ),
        ],
      ),
    );
  }
}
