import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../app/theme/app_colors.dart';

class OnboardingDeliveryView extends StatelessWidget {
  const OnboardingDeliveryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      child: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 112,
              left: -52,
              child: FloatingOrb(
                color: Colors.white.withValues(alpha: 0.06),
                diameter: 170,
                shift: 10,
              ),
            ),
            Positioned(
              right: -36,
              bottom: 192,
              child: FloatingOrb(
                color: Colors.white.withValues(alpha: 0.05),
                diameter: 126,
                shift: 16,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Spacer(flex: 3),
                  DeliveryHeroArtwork(),
                  SizedBox(height: 18),
                  Text(
                    'سائقين بخطوة.. توصيل أسرع من خيالك',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      height: 1.45,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Spacer(flex: 4),
                  HomeIndicator(),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DeliveryHeroArtwork extends StatelessWidget {
  const DeliveryHeroArtwork({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 210,
      height: 135,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            left: 12,
            bottom: 16,
            child: Container(
              width: 76,
              height: 122,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1F000000),
                    blurRadius: 18,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/image/image1.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            right: -4,
            bottom: -6,
            child: SizedBox(
              width: 154,
              height: 124,
              child: Lottie.asset(
                'assets/lolltie/Delivery guy.json',
                repeat: true,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeIndicator extends StatelessWidget {
  const HomeIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 86,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

class FloatingOrb extends StatelessWidget {
  const FloatingOrb({
    super.key,
    required this.color,
    required this.diameter,
    required this.shift,
  });

  final Color color;
  final double diameter;
  final double shift;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(math.sin(shift / 30) * 10, math.cos(shift / 22) * 8),
      child: Container(
        width: diameter,
        height: diameter,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
