import 'package:flutter/material.dart';

class MockLineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF4A7DFF)..strokeWidth = 3..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    final path = Path();
    path.moveTo(0, size.height * 0.8);
    path.quadraticBezierTo(size.width * 0.2, size.height * 0.9, size.width * 0.4, size.height * 0.5);
    path.quadraticBezierTo(size.width * 0.6, size.height * 0.1, size.width * 0.8, size.height * 0.4);
    path.quadraticBezierTo(size.width * 0.9, size.height * 0.5, size.width, size.height * 0.2);
    canvas.drawPath(path, paint);

    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [const Color.fromRGBO(74, 125, 255, 0.3), const Color.fromRGBO(255, 255, 255, 0.0)]).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    final fillPath = Path.from(path)..lineTo(size.width, size.height)..lineTo(0, size.height)..close();
    canvas.drawPath(fillPath, fillPaint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

Widget buildStatCard(String title, String value, IconData icon, Color color) {
  return Expanded(
    child: Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[200]!)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title, 
                  style: const TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w600),
                  maxLines: 2, 
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(8), 
                decoration: BoxDecoration(color: color.withAlpha((255 * 0.1).round()), borderRadius: BorderRadius.circular(8)), 
                child: Icon(icon, color: color, size: 20)
              )
            ],
          ),
          const SizedBox(height: 16),
          Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),
        ],
      ),
    ),
  );
}

Widget buildLegendDot(Color color, String text) {
  return Row(
    children: [
      Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 8),
      Text(text, style: const TextStyle(fontSize: 12, color: Colors.grey)),
    ],
  );
}

Widget buildActivityRow(String user, String action, String time) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Row(
      children: [
        Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF4A7DFF), shape: BoxShape.circle)),
        const SizedBox(width: 16),
        Expanded(
          child: RichText(text: TextSpan(style: const TextStyle(color: Colors.black87, fontSize: 14), children: [TextSpan(text: '$user ', style: const TextStyle(fontWeight: FontWeight.bold)), TextSpan(text: action)])),
        ),
        Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    ),
  );
}
