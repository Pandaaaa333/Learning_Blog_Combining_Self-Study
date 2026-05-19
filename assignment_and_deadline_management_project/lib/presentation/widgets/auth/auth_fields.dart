import 'package:flutter/material.dart';
import 'package:fe_admin_web/presentation/widgets/auth/custom_text_field.dart';

class AuthFields extends StatelessWidget {
  final bool isLogin;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const AuthFields({
    super.key,
    required this.isLogin,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isLogin) ...[
          const Text(
            'Họ và tên',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 8),
          CustomTextField(
            hint: 'VD: Tống Thiên Bảo',
            icon: Icons.person_outline_rounded,
            controller: nameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập họ và tên';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
        ],
        const Text(
          'Địa chỉ Email',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 8),
        CustomTextField(
          hint: 'admin@huce.edu.vn',
          icon: Icons.email_outlined,
          controller: emailController,
          validator: (value) {
            if (value == null || value.isEmpty || !value.contains('@')) {
              return 'Vui lòng nhập một địa chỉ email hợp lệ';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        const Text(
          'Mật khẩu',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 8),
        CustomTextField(
          hint: '••••••••',
          icon: Icons.lock_outline_rounded,
          isPassword: true,
          controller: passwordController,
          validator: (value) {
            if (value == null || value.isEmpty || value.length < 6) {
              return 'Mật khẩu phải có ít nhất 6 ký tự';
            }
            return null;
          },
        ),
      ],
    );
  }
}
