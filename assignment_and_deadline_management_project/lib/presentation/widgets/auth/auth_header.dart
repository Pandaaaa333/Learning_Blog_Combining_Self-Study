import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  final bool isLogin;

  const AuthHeader({super.key, required this.isLogin});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isLogin ? 'Đăng nhập Admin' : 'Đăng ký Admin',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          isLogin
              ? 'Vui lòng nhập thông tin của bạn'
              : 'Điền thông tin để tạo tài khoản',
          style: const TextStyle(color: Colors.grey, fontSize: 15),
        ),
      ],
    );
  }
}
