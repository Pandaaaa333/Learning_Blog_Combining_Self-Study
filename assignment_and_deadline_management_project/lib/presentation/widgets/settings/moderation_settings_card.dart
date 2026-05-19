import 'package:flutter/material.dart';
import 'package:fe_admin_web/presentation/widgets/settings/settings_card.dart';
import 'package:fe_admin_web/presentation/widgets/settings/switch_row.dart';

class ModerationSettingsCard extends StatefulWidget {
  const ModerationSettingsCard({super.key});

  @override
  State<ModerationSettingsCard> createState() => _ModerationSettingsCardState();
}

class _ModerationSettingsCardState extends State<ModerationSettingsCard> {
  bool _autoHideReportedPosts = true;
  final List<String> _bannedKeywords = [
    'chửi bậy',
    'mua bán điểm',
    'đáp án thi',
    'hack',
    'cờ bạc'
  ];
  final TextEditingController _keywordController = TextEditingController();

  void _addKeyword(String val) {
    if (val.trim().isNotEmpty && !_bannedKeywords.contains(val.trim())) {
      setState(() {
        _bannedKeywords.add(val.trim());
        _keywordController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SettingsCard(
      title: 'Kiểm duyệt nội dung',
      icon: Icons.shield_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SwitchRow(
            title: 'Tự động ẩn bài viết bị báo cáo',
            subtitle:
                'Các bài viết có trên 3 lượt Report sẽ tự động bị ẩn khỏi Bảng tin chờ duyệt.',
            value: _autoHideReportedPosts,
            onChanged: (val) => setState(() => _autoHideReportedPosts = val),
          ),
          const Divider(height: 32),
          const Text('Từ khóa cấm (Blacklist)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 8),
          const Text(
              'Hệ thống sẽ chặn các bài viết/bình luận chứa các từ khóa này.',
              style: TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _keywordController,
                  decoration: InputDecoration(
                    hintText: 'Nhập từ khóa cần chặn...',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                  onSubmitted: (val) => _addKeyword(val),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () => _addKeyword(_keywordController.text),
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A7DFF),
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                child: const Icon(Icons.add, color: Colors.white),
              )
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _bannedKeywords.map((keyword) {
              return Chip(
                label: Text(keyword),
                backgroundColor: Colors.red[50],
                labelStyle: const TextStyle(
                    color: Colors.red, fontWeight: FontWeight.w600),
                deleteIconColor: Colors.red,
                onDeleted: () {
                  setState(() => _bannedKeywords.remove(keyword));
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
