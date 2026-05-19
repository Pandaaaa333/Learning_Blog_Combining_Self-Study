import 'package:flutter/material.dart';
import 'package:fe_admin_web/domain/entities/subject_entity.dart';

class AddEditSubjectModal extends StatefulWidget {
  final AdminSubjectModel? subject;
  final Function(String? id, String name, String code) onSave;

  const AddEditSubjectModal({
    super.key,
    this.subject,
    required this.onSave,
  });

  @override
  State<AddEditSubjectModal> createState() => _AddEditSubjectModalState();
}

class _AddEditSubjectModalState extends State<AddEditSubjectModal> {
  final _nameCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();
  bool get _isEditing => widget.subject != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _nameCtrl.text = widget.subject!.name;
      _codeCtrl.text = widget.subject!.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titlePadding: EdgeInsets.zero,
      title: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color(0xFFF9FAFB),
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_isEditing ? 'Chỉnh sửa môn học' : 'Thêm môn học mới',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints()),
          ],
        ),
      ),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tên môn học',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: _nameCtrl,
              decoration: InputDecoration(
                  hintText: 'VD: Khai phá dữ liệu',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none)),
            ),
            const SizedBox(height: 16),
            const Text('Mã học phần',
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: _codeCtrl,
              decoration: InputDecoration(
                  hintText: 'VD: IT4040',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none)),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_nameCtrl.text.isNotEmpty && _codeCtrl.text.isNotEmpty) {
                    widget.onSave(
                        widget.subject?.id, _nameCtrl.text, _codeCtrl.text);
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A7DFF),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                child: Text(_isEditing ? 'Lưu thay đổi' : 'Thêm môn học',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
