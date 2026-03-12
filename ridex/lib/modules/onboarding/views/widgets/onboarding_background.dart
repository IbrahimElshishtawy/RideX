import 'dart:math' as math;

import 'package:flutter/material.dart';

class OnboardingBackground extends StatelessWidget {
  const OnboardingBackground({
    super.key,
    required this.phase,
  });

  final double phase;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 80 + math.sin(phase * 0.7) * 8,
          left: -60 + math.cos(phase * 0.5) * 6,
          child: _Orb(
            color: Colors.white.withValues(alpha: 0.07),
            diameter: 200,
          ),
        ),
        Positioned(
          right: -40 + math.cos(phase * 0.6) * 7,
          bottom: 160 + math.sin(phase * 0.8) * 9,
          child: _Orb(
            color: Colors.white.withValues(alpha: 0.05),
            diameter: 140,
          ),
        ),
        Positioned(
          top: 30 + math.sin(phase * 0.4) * 5,
          right: 30 + math.cos(phase * 0.9) * 5,
          child: _Orb(
            color: Colors.white.withValues(alpha: 0.08),
            diameter: 60,
          ),
        ),
        Positioned(
          bottom: -80,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              width: 320,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Orb extends StatelessWidget {
  const _Orb({
    required this.color,
    required this.diameter,
  });

  final Color color;
  final double diameter;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
