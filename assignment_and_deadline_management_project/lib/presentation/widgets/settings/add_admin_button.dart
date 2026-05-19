import 'package:flutter/material.dart';

class AddAdminButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AddAdminButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.person_add_rounded, size: 18),
        label: const Text('Thêm Admin mới'),
        style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            side: const BorderSide(color: Color(0xFF4A7DFF)),
            foregroundColor: const Color(0xFF4A7DFF)),
      ),
    );
  }
}
