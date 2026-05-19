import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onIndexSelected;
  final VoidCallback onLogout;

  const Sidebar({
    super.key,
    required this.selectedIndex,
    required this.onIndexSelected,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: const Color(0xFF4A7DFF), borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.school_rounded, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                const Text('Student Admin', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
              ],
            ),
          ),
          const Divider(height: 1),
          const SizedBox(height: 16),
          
          _buildNavItem(icon: Icons.dashboard_rounded, title: 'Tổng quan', index: 0),
          _buildNavItem(icon: Icons.people_alt_rounded, title: 'Người dùng', index: 1),
          _buildNavItem(icon: Icons.article_rounded, title: 'Bài viết & Feed', index: 2),
          _buildNavItem(icon: Icons.subject_rounded, title: 'Môn học (Onboarding)', index: 3),
          
          const Spacer(),
          const Divider(height: 1),
          _buildNavItem(icon: Icons.settings_rounded, title: 'Cài đặt hệ thống', index: 4),
          _buildNavItem(icon: Icons.logout_rounded, title: 'Đăng xuất', index: 5, iconColor: Colors.red, textColor: Colors.red),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required String title, required int index, Color? iconColor, Color? textColor}) {
    final isSelected = selectedIndex == index;
    final activeColor = const Color(0xFF4A7DFF);

    return InkWell(
      onTap: () {
        if (index == 5) {
          onLogout();
        } else {
          onIndexSelected(index);
        }
      },
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
