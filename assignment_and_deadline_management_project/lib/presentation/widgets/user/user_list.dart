import 'package:flutter/material.dart';
import 'package:fe_admin_web/domain/entities/user_entity.dart';
import 'package:fe_admin_web/presentation/widgets/user/user_data_table.dart';

class UserList extends StatelessWidget {
  final List<AdminUserModel> filteredUsers;
  final Function(AdminUserModel) onShowProfile;
  final Function(String) onToggleStatus;

  const UserList({
    super.key,
    required this.filteredUsers,
    required this.onShowProfile,
    required this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    return UserDataTable(
      users: filteredUsers,
      onShowProfile: onShowProfile,
      onToggleStatus: onToggleStatus,
    );
  }
}
