import 'package:flutter/material.dart';
import 'package:fe_admin_web/domain/entities/user_entity.dart';

class UserProfileModal extends StatelessWidget {
  final AdminUserModel user;

  const UserProfileModal({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.all(32),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(
              radius: 40, 
              backgroundColor: Color(0xFFE0E0E0),
              child: Icon(Icons.person, size: 40, color: Colors.grey)),
          const SizedBox(height: 16),
          Text(user.name,
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text(user.email,
              style: const TextStyle(color: Colors.grey, fontSize: 16)),
          const SizedBox(height: 32),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Chuyên ngành:'),
            Text(user.major ?? 'Chưa cập nhật', style: const TextStyle(fontWeight: FontWeight.bold))
          ]),
          const Divider(height: 24),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Ngày tham gia:'),
            Text(user.joinDate ?? 'Chưa cập nhật',
                style: const TextStyle(fontWeight: FontWeight.bold))
          ]),
          const Divider(height: 24),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Trạng thái:'),
            Text(user.isActive ? 'Đang hoạt động' : 'Bị khóa',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: user.isActive ? Colors.green : Colors.red))
          ]),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A7DFF),
                  padding: const EdgeInsets.symmetric(vertical: 16)),
              child: const Text('Đóng',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
}
