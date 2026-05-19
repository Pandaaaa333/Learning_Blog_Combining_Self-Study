import 'package:flutter/material.dart';

class SwitchRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SwitchRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 4),
              Text(subtitle,
                  style: const TextStyle(
                      color: Colors.grey, fontSize: 13, height: 1.4)),
            ],
          ),
        ),
        const SizedBox(width: 24),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: const Color(0xFF4A7DFF),
        ),
      ],
    );
  }
}
