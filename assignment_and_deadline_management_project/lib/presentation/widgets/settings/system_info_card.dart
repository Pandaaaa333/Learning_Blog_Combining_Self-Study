import 'package:flutter/material.dart';
import 'package:fe_admin_web/presentation/widgets/settings/settings_card.dart';

class SystemInfoCard extends StatelessWidget {
  const SystemInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsCard(
      title: 'Thông tin Server',
      icon: Icons.dns_rounded,
      child: Column(
        children: [
          _buildInfoRow('Phiên bản hệ thống', 'v2.4.0 (Stable)'),
          const Divider(height: 24),
          _buildInfoRow('Máy chủ cơ sở dữ liệu', 'Firebase Firestore'),
          const Divider(height: 24),
          _buildInfoRow('Dung lượng lưu trữ', '124 GB / 5 TB'),
          const Divider(height: 24),
          _buildInfoRow('Lần cập nhật cuối', '04/05/2026'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        Text(value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }
}
