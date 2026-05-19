import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final bool isLogin;
  final VoidCallback onSubmit;

  const SubmitButton({
    super.key,
    required this.isLogin,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4A7DFF),
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          isLogin ? 'Đăng nhập' : 'Tạo tài khoản',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
