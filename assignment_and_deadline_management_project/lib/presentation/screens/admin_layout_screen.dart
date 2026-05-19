import 'package:flutter/material.dart';
import 'package:fe_admin_web/presentation/screens/user_management_screen.dart';
import 'package:fe_admin_web/presentation/screens/feed_management_screen.dart';
import 'package:fe_admin_web/presentation/screens/subject_management_screen.dart';
import 'package:fe_admin_web/presentation/screens/settings_screen.dart';
import 'package:fe_admin_web/presentation/screens/auth_screen.dart';
import 'package:fe_admin_web/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:fe_admin_web/presentation/widgets/sidebar.dart';
import 'package:fe_admin_web/presentation/widgets/top_app_bar.dart';

class AdminLayoutScreen extends StatefulWidget {
  const AdminLayoutScreen({super.key});

  @override
  State<AdminLayoutScreen> createState() => _AdminLayoutScreenState();
}

class _AdminLayoutScreenState extends State<AdminLayoutScreen> {
  int _selectedIndex = 0;

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận đăng xuất', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Bạn có chắc chắn muốn thoát khỏi hệ thống quản trị không?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Hủy', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx); // Đóng dialog
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AuthScreen()),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Đăng xuất', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: Row(
        children: [
          Sidebar(
            selectedIndex: _selectedIndex,
            onIndexSelected: (index) => setState(() => _selectedIndex = index),
            onLogout: () => _showLogoutDialog(context),
          ),
          Expanded(
            child: Column(
              children: [
                TopAppBar(title: _getPageTitle()),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: _buildMainContent(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // HÀM QUẢN LÝ CHUYỂN TRANG
  // ==========================================
  Widget _buildMainContent() {
    switch (_selectedIndex) {
      case 0:
        return const DashboardScreen();
      case 1:
        return const UserManagementScreen();
      case 2:
        return const FeedManagementScreen();
      case 3:
        return const SubjectManagementScreen();
      case 4:
        return const SettingsScreen();
      default:
        return Center(
            child: Text('Đang phát triển nội dung cho: ${_getPageTitle()}',
                style: const TextStyle(fontSize: 18, color: Colors.grey)));
    }
  }

  String _getPageTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Tổng quan hệ thống';
      case 1:
        return 'Quản lý Người dùng';
      case 2:
        return 'Kiểm duyệt Bài viết';
      case 3:
        return 'Danh mục Môn học';
      case 4:
        return 'Cài đặt chung';
      default:
        return 'Dashboard';
    }
  }
}