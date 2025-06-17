import 'dart:math';
import 'package:flutter/material.dart';

class SplashPainter extends CustomPainter {
  final double progress;
  final double radiusFactor; // controls size of the circle

  SplashPainter({
    required this.progress,
    this.radiusFactor = 0.4, // adjust this for larger/smaller circle
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // radius grows based on progress (if animating)
    final radius = size.shortestSide * radiusFactor + 20 * progress;

    final rect = Rect.fromCircle(center: center, radius: radius);

    final gradient = LinearGradient(
      colors: [Colors.cyan.shade100, Colors.purple.shade100],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant SplashPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.radiusFactor != radiusFactor;
  }
}

class BackgroundDotsPainter extends CustomPainter {
  final List<Offset> positions;
  BackgroundDotsPainter({required this.positions});

  @override
  void paint(Canvas canvas, Size size) {
    final gradient = const LinearGradient(
      colors: [Color(0xFFE0F7FA), Color(0xFFF3E5F5)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    final shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..shader = shader;

    for (var pos in positions) {
      final radius = 1.5 + (pos.dx * pos.dy) % 2.0;
      canvas.drawCircle(pos, radius, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
