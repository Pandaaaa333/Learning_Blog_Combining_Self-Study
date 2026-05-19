import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fe_mobile/features/auth/presentation/views/login_screen.dart';
import 'package:fe_mobile/features/auth/presentation/widgets/primary_button.dart';

class ProfileLoggedOutView extends StatelessWidget {
  const ProfileLoggedOutView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF52B794).withOpacity(0.05),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                // Icon Illustration
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF52B794).withOpacity(0.15),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.account_circle_rounded,
                    size: 100,
                    color: Color(0xFF52B794),
                  ),
                ),
                const SizedBox(height: 48),
                Text(
                  'Hồ sơ của bạn',
                  style: GoogleFonts.beVietnamPro(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Đăng nhập để xem hồ sơ cá nhân, theo dõi bài viết và quản lý các mục đã lưu của bạn một cách dễ dàng.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.beVietnamPro(
                    color: Colors.grey[600],
                    fontSize: 16,
                    height: 1.6,
                  ),
                ),
                const Spacer(),
                PrimaryButton(
                  text: 'Đăng nhập ngay',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    // Logic skip or info
                  },
                  child: Text(
                    'Tìm hiểu thêm về chúng tôi',
                    style: GoogleFonts.beVietnamPro(
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
