import 'package:flutter/material.dart';
import 'package:fe_admin_web/presentation/widgets/settings/general_settings_card.dart';
import 'package:fe_admin_web/presentation/widgets/settings/moderation_settings_card.dart';
import 'package:fe_admin_web/presentation/widgets/settings/admin_roles_card.dart';
import 'package:fe_admin_web/presentation/widgets/settings/system_info_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // THÀNH PHẦN 1: HEADER & NÚT LƯU
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Cấu hình hệ thống',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            ElevatedButton.icon(
              onPressed: () {
                // Hiển thị thông báo lưu thành công
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Đã lưu cấu hình hệ thống!'),
                      backgroundColor: Colors.green),
                );
              },
              icon: const Icon(Icons.save_rounded, color: Colors.white),
              label: const Text('Lưu thay đổi',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A7DFF),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // THÀNH PHẦN 2: NỘI DUNG CÀI ĐẶT (Chia làm 2 cột)
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CỘT TRÁI: Cài đặt chung & Kiểm duyệt
                Expanded(
                  flex: 3,
                  child: Column(
                    children: const [
                      GeneralSettingsCard(),
                      SizedBox(height: 24),
                      ModerationSettingsCard(),
                    ],
                  ),
                ),

                const SizedBox(width: 24),

                // CỘT PHẢI: Thông tin Server & Admin
                Expanded(
                  flex: 2,
                  child: Column(
                    children: const [
                      AdminRolesCard(),
                      SizedBox(height: 24),
                      SystemInfoCard(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}