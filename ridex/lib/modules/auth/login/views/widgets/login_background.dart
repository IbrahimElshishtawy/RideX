import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';

class LoginBackground extends StatelessWidget {
  const LoginBackground({
    super.key,
    required this.phase,
  });

  final double phase;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -80 + math.sin(phase * 0.6) * 18,
          right: -60 + math.cos(phase * 0.4) * 14,
          child: _Glow(
            color: AppColors.primary.withValues(alpha: 0.18),
            size: 300,
          ),
        ),
        Positioned(
          bottom: -60 + math.cos(phase * 0.5) * 14,
          left: -40 + math.sin(phase * 0.7) * 10,
          child: _Glow(
            color: AppColors.primary.withValues(alpha: 0.10),
            size: 240,
          ),
        ),
        Positioned.fill(
          child: CustomPaint(
            painter: _DotGridPainter(),
          ),
        ),
      ],
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({
    required this.color,
    required this.size,
  });

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, Colors.transparent]),
      ),
    );
  }
}

class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.045)
      ..strokeCap = StrokeCap.round;
    const gap = 24.0;
    for (double x = 0; x < size.width; x += gap) {
      for (double y = 0; y < size.height; y += gap) {
        canvas.drawCircle(Offset(x, y), 1.2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
