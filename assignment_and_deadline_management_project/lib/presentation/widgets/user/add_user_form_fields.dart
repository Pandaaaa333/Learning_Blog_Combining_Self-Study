import 'package:flutter/material.dart';
import 'package:fe_admin_web/presentation/widgets/user/user_input_field.dart';

class AddUserFormFields extends StatelessWidget {
  final TextEditingController nameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController passwordCtrl;
  final TextEditingController majorCtrl;

  const AddUserFormFields({
    super.key,
    required this.nameCtrl,
    required this.emailCtrl,
    required this.passwordCtrl,
    required this.majorCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserInputField(
          controller: nameCtrl,
          label: 'Họ và tên',
          hint: 'VD: Nguyễn Văn A',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Vui lòng nhập họ và tên';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        UserInputField(
          controller: emailCtrl,
          label: 'Email',
          hint: 'VD: email@huce.edu.vn',
          validator: (value) {
            if (value == null || value.isEmpty || !value.contains('@')) {
              return 'Vui lòng nhập một địa chỉ email hợp lệ';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        UserInputField(
          controller: passwordCtrl,
          label: 'Mật khẩu',
          hint: 'Nhập mật khẩu khởi tạo',
          isPassword: true,
          validator: (value) {
            if (value == null || value.isEmpty || value.length < 6) {
              return 'Mật khẩu phải có ít nhất 6 ký tự';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        UserInputField(
          controller: majorCtrl,
          label: 'Chuyên ngành',
          hint: 'VD: CNTT',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Vui lòng nhập chuyên ngành';
            }
            return null;
          },
        ),
      ],
    );
  }
}
