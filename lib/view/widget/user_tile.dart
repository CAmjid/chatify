import 'package:chatify/view/widget/app_text.dart';
import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String text;
  final String name;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const UserTile({
    super.key,
    required this.text,
    required this.name,
    this.onTap,
    this.onLongPress,
  });

  String formatName(String name) {
    if (name.isEmpty) return name;
    return name[0].toUpperCase() + name.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                child: AppText(
                  name: name[0].toUpperCase(),
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 46, 20, 151),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppText(
                  name: formatName(text),
                  fontsize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
