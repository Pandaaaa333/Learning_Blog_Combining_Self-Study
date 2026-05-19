import 'package:flutter/material.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF52B794);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Quên mật khẩu', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 32),
            
            // Phone or Email (cite: image_9.png)
            const TextField(
              decoration: InputDecoration(hintText: 'Phone or Email'),
            ),
            const SizedBox(height: 16),
            
            // New Password (cite: image_9.png)
            const TextField(
              obscureText: true,
              decoration: InputDecoration(hintText: 'New Password'),
            ),
            const SizedBox(height: 16),
            
            // Confirm Password (cite: image_9.png)
            const TextField(
              obscureText: true,
              decoration: InputDecoration(hintText: 'Confirm Password'),
            ),
            const SizedBox(height: 32),
            
            // Nút CONFIRM (cite: image_9.png)
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // Xử lý logic xác nhận
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text('CONFIRM', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
