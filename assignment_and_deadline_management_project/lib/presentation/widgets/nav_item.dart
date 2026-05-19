import 'package:flutter/material.dart';

class NavItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final int index;
  final int selectedIndex;
  final Function(int) onTap;
  final Color? iconColor;
  final Color? textColor;

  const NavItem({
    super.key,
    required this.icon,
    required this.title,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedIndex == index;
    final activeColor = const Color(0xFF4A7DFF);

    return InkWell(
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withOpacity(0.1) : Colors.transparent,
          border: Border(right: BorderSide(color: isSelected ? activeColor : Colors.transparent, width: 3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? activeColor : (iconColor ?? Colors.black54), size: 22),
            const SizedBox(width: 16),
            Text(title, style: TextStyle(color: isSelected ? activeColor : (textColor ?? Colors.black87), fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, fontSize: 15)),
          ],
        ),
      ),
    );
  }
}
