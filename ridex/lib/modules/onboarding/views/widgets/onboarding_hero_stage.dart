import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../controllers/onboarding_controller.dart';
import '../../../../app/theme/app_colors.dart';

class OnboardingHeroStage extends GetView<OnboardingController> {
  const OnboardingHeroStage({
    super.key,
    required this.screenWidth,
  });

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          const Positioned(
            bottom: 12,
            child: _GroundShadow(),
          ),
          AnimatedBuilder(
            animation: controller.pulseController,
            builder: (_, _) => Opacity(
              opacity: controller.pulseOpacity.value,
              child: Transform.scale(
                scale: controller.pulseScale.value,
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Obx(() {
            if (controller.exiting.value) {
              return const SizedBox.shrink();
            }

            return AnimatedBuilder(
              animation: controller.riderController,
              builder: (_, _) {
                final t = controller.riderController.value;
                if (t >= 1) {
                  return const SizedBox.shrink();
                }
                return Positioned(
                  right: screenWidth * 0.5 - screenWidth * (1 - t) * 0.5 + 60,
                  child: Opacity(
                    opacity: (1 - t).clamp(0, 1),
                    child: const _SpeedLines(),
                  ),
                );
              },
            );
          }),
          AnimatedBuilder(
            animation: Listenable.merge([
              controller.riderController,
              controller.exitController,
            ]),
            builder: (_, _) {
              final enterOffset =
                  -(screenWidth + 100) * (1 - controller.riderX.value);
              final exitOffset = (screenWidth + 100) * controller.exitX.value;

              return Transform.translate(
                offset: Offset(
                  enterOffset + exitOffset,
                  controller.riderY.value,
                ),
                child: Opacity(
                  opacity: controller.riderOpacity.value,
                  child: const _RiderCard(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _GroundShadow extends StatelessWidget {
  const _GroundShadow();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 148,
      height: 18,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.10),
            Colors.black.withValues(alpha: 0.18),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.08),
            blurRadius: 10,
            spreadRadius: -3,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.06),
          ),
        ),
      ),
    );
  }
}

class _RiderCard extends StatelessWidget {
  const _RiderCard();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 170,
          height: 170,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.08),
          ),
        ),
        SizedBox(
          width: 170,
          height: 170,
          child: Lottie.asset(
            'assets/lolltie/Delivery guy.json',
            repeat: true,
            fit: BoxFit.contain,
          ),
        ),
        const Positioned(
          top: -8,
          right: -8,
          child: _EtaBadge(),
        ),
      ],
    );
  }
}

class _EtaBadge extends StatelessWidget {
  const _EtaBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.access_time_rounded,
            size: 12,
            color: AppColors.primary,
          ),
          const SizedBox(width: 4),
          Text(
            '15 دقيقة',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _SpeedLines extends StatelessWidget {
  const _SpeedLines();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: const [
        _SpeedLine(width: 60),
        SizedBox(height: 7),
        _SpeedLine(width: 38),
        SizedBox(height: 7),
        _SpeedLine(width: 50),
      ],
    );
  }
}

class _SpeedLine extends StatelessWidget {
  const _SpeedLine({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 3,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}
