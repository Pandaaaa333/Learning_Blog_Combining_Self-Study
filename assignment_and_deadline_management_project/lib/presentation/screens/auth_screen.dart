import 'package:flutter/material.dart';
import 'package:fe_admin_web/presentation/widgets/auth/auth_banner.dart';
import 'package:fe_admin_web/presentation/widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;

  void _toggleForm() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: Center(
        child: Container(
          width: 900,
          height: 550,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                  color: const Color.fromRGBO(0, 0, 0, 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10)),
            ],
          ),
          child: Row(
            children: [
              AuthBanner(isLogin: _isLogin),
              AuthForm(
                isLogin: _isLogin,
                toggleForm: _toggleForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}