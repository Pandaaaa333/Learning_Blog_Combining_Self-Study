import 'package:flutter/material.dart';

class UserManagementHeader extends StatelessWidget {
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onFilterChanged;
  final VoidCallback onAddUser;
  final String selectedFilter;

  const UserManagementHeader({
    super.key,
    required this.onSearchChanged,
    required this.onFilterChanged,
    required this.onAddUser,
    required this.selectedFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 350,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!)),
          child: TextField(
            onChanged: onSearchChanged,
            decoration: const InputDecoration(
                hintText: 'Tìm kiếm theo tên hoặc email...',
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
          ),
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedFilter,
                  items: ['Tất cả', 'Hoạt động', 'Bị khóa']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: onFilterChanged,
                ),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: onAddUser,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Thêm tài khoản',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A7DFF),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  elevation: 0),
            ),
          ],
        )
      ],
    );
  }
}
