import 'package:flutter/material.dart';
import 'package:fe_admin_web/domain/entities/user_entity.dart';
import 'package:fe_admin_web/presentation/widgets/user/add_user_modal.dart';
import 'package:fe_admin_web/presentation/widgets/user/user_list.dart';
import 'package:fe_admin_web/presentation/widgets/user/user_management_header.dart';
import 'package:fe_admin_web/presentation/widgets/user/user_profile_modal.dart';
import 'package:provider/provider.dart';
import 'package:fe_admin_web/data/providers/user_provider.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'Tất cả';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().fetchUsers();
    });
  }

  void _toggleUserStatus(String userId) async {
    await context.read<UserProvider>().toggleUserStatus(userId);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã cập nhật trạng thái người dùng!'),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.blue
      )
    );
  }

  void _showUserProfile(AdminUserModel user) {
    showDialog(
      context: context,
      builder: (ctx) => UserProfileModal(user: user),
    );
  }

  void _addUser(String name, String email, String password, String major) async {
    // Implement API call to add user using AuthProvider or UserProvider.
    // For now we just mock or call provider later.
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Đã thêm tài khoản thành công!'),
        backgroundColor: Colors.green));
  }

  void _showAddUserModal() {
    showDialog(
      context: context,
      builder: (ctx) => AddUserModal(onAdd: _addUser),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final filteredUsers = userProvider.users.where((user) {
          final matchesSearch = user.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              user.email.toLowerCase().contains(_searchQuery.toLowerCase());
          final matchesFilter = _selectedFilter == 'Tất cả' ||
              (_selectedFilter == 'Hoạt động' && user.isActive) ||
              (_selectedFilter == 'Bị khóa' && !user.isActive);
          return matchesSearch && matchesFilter;
        }).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserManagementHeader(
              onSearchChanged: (value) => setState(() => _searchQuery = value),
              onFilterChanged: (value) => setState(() => _selectedFilter = value!),
              onAddUser: _showAddUserModal,
              selectedFilter: _selectedFilter,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: userProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : userProvider.error != null
                      ? Center(child: Text(userProvider.error!, style: const TextStyle(color: Colors.red)))
                      : UserList(
                          filteredUsers: filteredUsers,
                          onShowProfile: _showUserProfile,
                          onToggleStatus: _toggleUserStatus,
                        ),
            ),
          ],
        );
      },
    );
  }
}