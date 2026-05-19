import 'package:flutter/material.dart';

class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const TopAppBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Row(
            children: [
              // THAY ĐỔI Ở ĐÂY: Sử dụng PopupMenuButton cho thông báo
              PopupMenuButton<int>(
                offset: const Offset(0, 50), // Đẩy menu xuống dưới icon
                icon: const Icon(Icons.notifications_none_rounded, color: Colors.black54),
                tooltip: 'Thông báo',
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                itemBuilder: (context) => [
                  // Tiêu đề menu
                  PopupMenuItem(
                    enabled: false,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Thông báo', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                        TextButton(onPressed: () {}, child: const Text('Xem tất cả', style: TextStyle(fontSize: 12))),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  // Danh sách các thông báo mẫu
                  _buildNotificationItem(
                    title: 'Người dùng mới',
                    subtitle: 'Nguyễn Văn A vừa đăng ký tài khoản.',
                    time: '2 phút trước',
                    icon: Icons.person_add,
                    color: Colors.blue,
                  ),
                  _buildNotificationItem(
                    title: 'Lịch hẹn mới',
                    subtitle: 'Bạn có một lịch hẹn khám lúc 14:00.',
                    time: '1 giờ trước',
                    icon: Icons.calendar_today,
                    color: Colors.green,
                  ),
                  _buildNotificationItem(
                    title: 'Cảnh báo hệ thống',
                    subtitle: 'Máy chủ đang bảo trì định kỳ.',
                    time: '5 giờ trước',
                    icon: Icons.warning_amber_rounded,
                    color: Colors.orange,
                  ),
                ],
              ),
              const SizedBox(width: 24),
              const CircleAvatar(
                  radius: 18,
                  backgroundColor: Color(0xFFE0E0E0),
                  child: Icon(Icons.person, color: Colors.grey)),
              const SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Super Admin',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text('admin@system.com',
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  // Hàm bổ trợ để tạo từng dòng thông báo
  PopupMenuItem<int> _buildNotificationItem({
    required String title,
    required String subtitle,
    required String time,
    required IconData icon,
    required Color color,
  }) {
    return PopupMenuItem<int>(
      child: Container(
        width: 300, // Chiều rộng của menu thông báo
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  Text(subtitle, style: const TextStyle(fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(time, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
