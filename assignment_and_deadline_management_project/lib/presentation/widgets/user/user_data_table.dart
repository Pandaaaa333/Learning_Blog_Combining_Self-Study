import 'package:flutter/material.dart';
import 'package:fe_admin_web/domain/entities/user_entity.dart';

class UserDataTable extends StatelessWidget {
  final List<AdminUserModel> users;
  final Function(AdminUserModel user) onShowProfile;
  final Function(String userId) onToggleStatus;

  const UserDataTable({
    super.key,
    required this.users,
    required this.onShowProfile,
    required this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.resolveWith(
                  (states) => const Color(0xFFF9FAFB)),
              dataRowMinHeight: 70,
              dataRowMaxHeight: 70,
              horizontalMargin: 24,
              columnSpacing: 40,
              columns: const [
                DataColumn(
                    label: Text('Người dùng',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87))),
                DataColumn(
                    label: Text('Chuyên ngành',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87))),
                DataColumn(
                    label: Text('Ngày tham gia',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87))),
                DataColumn(
                    label: Text('Trạng thái',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87))),
                DataColumn(
                    label: Text('Hành động',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87))),
              ],
              rows: users.map((user) => _buildDataRow(user)).toList(),
            ),
          ),
        ),
      ),
    );
  }

  DataRow _buildDataRow(AdminUserModel user) {
    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[200],
                  child: const Icon(Icons.person, color: Colors.grey)),
              const SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.black87)),
                  Text(user.email,
                      style: const TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
            ],
          ),
        ),
        DataCell(Text(user.major ?? 'Chưa cập nhật',
            style: const TextStyle(color: Colors.black87))),
        DataCell(Text(user.joinDate ?? 'Chưa cập nhật',
            style: const TextStyle(color: Colors.black87))),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: user.isActive
                  ? const Color(0xFF10B981).withOpacity(0.1)
                  : const Color(0xFFEF4444).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              user.isActive ? 'Hoạt động' : 'Bị khóa',
              style: TextStyle(
                color: user.isActive
                    ? const Color(0xFF10B981)
                    : const Color(0xFFEF4444),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
        DataCell(
          Row(
            children: [
              IconButton(
                icon:
                    const Icon(Icons.remove_red_eye_outlined, color: Colors.blue),
                tooltip: 'Xem hồ sơ',
                onPressed: () => onShowProfile(user),
              ),
              IconButton(
                icon: Icon(
                    user.isActive
                        ? Icons.lock_open_rounded
                        : Icons.lock_outline_rounded,
                    color: user.isActive ? Colors.green : Colors.red),
                tooltip: user.isActive ? 'Khóa tài khoản' : 'Mở khóa',
                onPressed: () => onToggleStatus(user.id),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
