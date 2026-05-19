import 'package:flutter/material.dart';
import 'package:fe_admin_web/domain/entities/admin_entity.dart';

class AdminListItem extends StatelessWidget {
  final Admin admin;
  const AdminListItem({super.key, required this.admin});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          const CircleAvatar(
              radius: 18, 
              backgroundColor: Color(0xFFE0E0E0),
              child: Icon(Icons.person, color: Colors.grey)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(admin.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(width: 8),
                    if (admin.isSuperAdmin)
                      Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(4)),
                          child: const Text('Trưởng',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold))),
                  ],
                ),
                Text(admin.email,
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
