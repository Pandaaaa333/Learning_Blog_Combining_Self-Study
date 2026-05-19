import 'package:flutter/material.dart';

class SubjectManagementHeader extends StatelessWidget {
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onAddSubject;

  const SubjectManagementHeader({
    super.key,
    required this.onSearchChanged,
    required this.onAddSubject,
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
                hintText: 'Tìm kiếm theo tên môn hoặc mã...',
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
          ),
        ),
        ElevatedButton.icon(
          onPressed: onAddSubject,
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text('Thêm môn học',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A7DFF),
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              elevation: 0),
        ),
      ],
    );
  }
}
