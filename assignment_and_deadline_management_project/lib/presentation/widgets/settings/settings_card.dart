import 'package:flutter/material.dart';

class SettingsCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const SettingsCard({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(74, 125, 255, 0.1),
                      borderRadius: BorderRadius.circular(8)),
                  child: Icon(icon, color: const Color(0xFF4A7DFF), size: 20)),
              const SizedBox(width: 12),
              Text(title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }
}
