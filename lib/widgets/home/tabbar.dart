import 'package:flutter/material.dart';

class TabBar extends StatelessWidget {

  final String name;
  final bool isSelected;
  final IconData correctIcon;
  TabBar({required this.name, required this.isSelected, required this.correctIcon});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(correctIcon, color: isSelected ? Colors.blue : Colors.grey,)
      ],
    );
  }
}
