import 'package:flutter/material.dart';
import 'package:fe_admin_web/presentation/widgets/settings/settings_card.dart';
import 'package:fe_admin_web/presentation/widgets/settings/switch_row.dart';

class GeneralSettingsCard extends StatefulWidget {
  const GeneralSettingsCard({super.key});

  @override
  State<GeneralSettingsCard> createState() => _GeneralSettingsCardState();
}

class _GeneralSettingsCardState extends State<GeneralSettingsCard> {
  bool _maintenanceMode = false;
  bool _allowNewRegistrations = true;
  bool _enableEmailNotifications = true;

  @override
  Widget build(BuildContext context) {
    return SettingsCard(
      title: 'Cài đặt chung',
      icon: Icons.settings_rounded,
      child: Column(
        children: [
          SwitchRow(
            title: 'Bật chế độ bảo trì',
            subtitle:
                'Khi bật, toàn bộ hệ thống sẽ tạm ngưng hoạt động để bảo trì.',
            value: _maintenanceMode,
            onChanged: (val) => setState(() => _maintenanceMode = val),
          ),
          const Divider(height: 32),
          SwitchRow(
            title: 'Cho phép người dùng mới đăng ký',
            subtitle:
                'Nếu tắt, người dùng mới sẽ không thể tạo tài khoản trên hệ thống.',
            value: _allowNewRegistrations,
            onChanged: (val) => setState(() => _allowNewRegistrations = val),
          ),
          const Divider(height: 32),
          SwitchRow(
            title: 'Bật thông báo qua Email',
            subtitle:
                'Gửi email cho quản trị viên khi có các sự kiện quan trọng.',
            value: _enableEmailNotifications,
            onChanged: (val) => setState(() => _enableEmailNotifications = val),
          ),
        ],
      ),
    );
  }
}
