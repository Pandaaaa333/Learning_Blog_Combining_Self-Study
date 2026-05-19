import 'package:flutter/material.dart';
import 'package:fe_admin_web/presentation/widgets/user/modal_header.dart';
import 'package:fe_admin_web/presentation/widgets/user/add_user_form_fields.dart';
import 'package:fe_admin_web/presentation/widgets/user/create_account_button.dart';

class AddUserModal extends StatefulWidget {
  final Function(String name, String email, String password, String major)
      onAdd;

  const AddUserModal({super.key, required this.onAdd});

  @override
  State<AddUserModal> createState() => _AddUserModalState();
}

class _AddUserModalState extends State<AddUserModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _majorCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onAdd(
        _nameCtrl.text,
        _emailCtrl.text,
        _passwordCtrl.text,
        _majorCtrl.text,
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titlePadding: EdgeInsets.zero,
      title: const ModalHeader(title: 'Thêm tài khoản mới'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AddUserFormFields(
                  nameCtrl: _nameCtrl,
                  emailCtrl: _emailCtrl,
                  passwordCtrl: _passwordCtrl,
                  majorCtrl: _majorCtrl,
                ),
                const SizedBox(height: 24),
                CreateAccountButton(onPressed: _submit),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
