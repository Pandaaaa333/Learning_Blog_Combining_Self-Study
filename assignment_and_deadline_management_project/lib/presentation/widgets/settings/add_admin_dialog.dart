import 'package:flutter/material.dart';
import 'package:fe_admin_web/domain/entities/admin_entity.dart';

class AddAdminDialog extends StatefulWidget {
  final Function(Admin) onAddAdmin;

  const AddAdminDialog({super.key, required this.onAddAdmin});

  @override
  State<AddAdminDialog> createState() => _AddAdminDialogState();
}

class _AddAdminDialogState extends State<AddAdminDialog> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void _submit() {
    // CHECK VALIDATE
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final newAdmin = Admin(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      avatar:
          'https://i.pravatar.cc/150?u=${DateTime.now().millisecondsSinceEpoch}',
    );

    widget.onAddAdmin(newAdmin);

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Thêm admin thành công'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Thêm Admin mới'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // NAME
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Tên',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Vui lòng nhập tên';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // EMAIL
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Vui lòng nhập email';
                }

                if (!value.contains('@')) {
                  return 'Email không hợp lệ';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            // PASSWORD
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Mật khẩu',
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Vui lòng nhập mật khẩu';
                }

                if (value.length < 6) {
                  return 'Mật khẩu tối thiểu 6 ký tự';
                }

                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Thêm'),
        ),
      ],
    );
  }
}
