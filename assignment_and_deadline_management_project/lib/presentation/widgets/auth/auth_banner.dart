import 'package:flutter/material.dart';

class AuthBanner extends StatelessWidget {
  final bool isLogin;

  const AuthBanner({super.key, required this.isLogin});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 5,
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF4A7DFF),
          borderRadius: BorderRadius.horizontal(left: Radius.circular(24)),
          gradient: LinearGradient(
            colors: [Color(0xFF4A7DFF), Color(0xFF2E5BFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12)),
                child:
                    const Icon(Icons.school_rounded, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 32),
              Text(
                isLogin ? 'Chào mừng\ntrở lại!' : 'Tham gia\nHệ thống',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    height: 1.2),
              ),
              const SizedBox(height: 16),
              Text(
                isLogin
                    ? 'Đăng nhập để truy cập vào bảng điều khiển và quản lý cộng đồng sinh viên của bạn.'
                    : 'Tạo tài khoản quản trị viên mới để cùng xây dựng cộng đồng học tập.',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 16,
                    height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
