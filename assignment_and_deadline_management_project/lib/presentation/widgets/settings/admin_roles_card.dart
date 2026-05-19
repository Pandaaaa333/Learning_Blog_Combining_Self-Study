import 'package:flutter/material.dart';
import 'package:fe_admin_web/domain/entities/admin_entity.dart';
import 'package:fe_admin_web/presentation/widgets/settings/settings_card.dart';
import 'package:fe_admin_web/presentation/widgets/settings/admin_list_item.dart';
import 'package:fe_admin_web/presentation/widgets/settings/add_admin_dialog.dart';
import 'package:fe_admin_web/presentation/widgets/settings/add_admin_button.dart';

class AdminRolesCard extends StatefulWidget {
  const AdminRolesCard({super.key});

  @override
  _AdminRolesCardState createState() => _AdminRolesCardState();
}

class _AdminRolesCardState extends State<AdminRolesCard> {
  final List<Admin> _admins = [
    Admin(
        name: 'Super Admin',
        email: 'admin@system.com',
        avatar: 'https://i.pravatar.cc/150?u=admin',
        isSuperAdmin: true),
    Admin(
        name: 'Tống Thiên Bảo',
        email: 'baott@huce.edu.vn',
        avatar: 'https://i.pravatar.cc/150?u=me_123'),
  ];

  void _addAdmin(Admin admin) {
    setState(() {
      _admins.add(admin);
    });
  }

  void _showAddAdminDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AddAdminDialog(onAddAdmin: _addAdmin);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SettingsCard(
      title: 'Danh sách Quản trị viên',
      icon: Icons.admin_panel_settings_rounded,
      child: Column(
        children: [
          ..._admins.map((admin) => AdminListItem(admin: admin)),
          const SizedBox(height: 16),
          AddAdminButton(onPressed: _showAddAdminDialog),
        ],
      ),
    );
  }
}
