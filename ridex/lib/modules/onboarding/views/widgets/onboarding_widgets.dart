import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../app/theme/app_colors.dart';

class OnboardingDeliveryView extends StatefulWidget {
  const OnboardingDeliveryView({super.key});

  @override
  State<OnboardingDeliveryView> createState() => _OnboardingDeliveryViewState();
}

class _OnboardingDeliveryViewState extends State<OnboardingDeliveryView>
    with TickerProviderStateMixin {
  late final AnimationController _riderController;
  late final Animation<double> _riderX;
  late final Animation<double> _riderY;
  late final Animation<double> _riderOpacity;

  late final AnimationController _exitController;
  late final Animation<double> _exitX;

  late final AnimationController _uiFadeController;
  late final Animation<double> _uiOpacity;

  late final AnimationController _pulseController;
  late final Animation<double> _pulseScale;
  late final Animation<double> _pulseOpacity;

  late final AnimationController _orbController;

  bool _exiting = false;

  @override
  void initState() {
    super.initState();

    _riderController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _riderX = CurvedAnimation(
      parent: _riderController,
      curve: Curves.easeOutCubic,
    );
    _riderY = TweenSequence<double>([
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.0, end: -14.0),
        weight: 60,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(
          begin: -14.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.bounceOut)),
        weight: 40,
      ),
    ]).animate(_riderController);
    _riderOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _riderController,
        curve: const Interval(0, 0.3, curve: Curves.easeIn),
      ),
    );

    _uiFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _uiOpacity = CurvedAnimation(
      parent: _uiFadeController,
      curve: Curves.easeInOut,
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    _pulseScale = Tween<double>(
      begin: 0.6,
      end: 2.2,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeOut));
    _pulseOpacity = Tween<double>(
      begin: 0.55,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeOut));

    _orbController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    _exitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 820),
    );
    _exitX = CurvedAnimation(
      parent: _exitController,
      curve: Curves.easeInCubic,
    );

    _runSequence();
  }

  Future<void> _runSequence() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _uiFadeController.forward();
    await _riderController.forward();
    _pulseController.repeat();
    await Future.delayed(const Duration(milliseconds: 2000));
    _pulseController.stop();
    setState(() => _exiting = true);
    await _exitController.forward();

    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  void dispose() {
    _riderController.dispose();
    _exitController.dispose();
    _uiFadeController.dispose();
    _pulseController.dispose();
    _orbController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final sw = size.width;

    return ColoredBox(
      color: AppColors.primary,
      child: SafeArea(
        child: Stack(
          children: [
            _buildBackground(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: 360,
                          maxHeight: size.height * 0.54,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 220,
                              child: Stack(
                                alignment: Alignment.center,
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                    bottom: 12,
                                    child: _buildGroundShadow(),
                                  ),
                                  AnimatedBuilder(
                                    animation: _pulseController,
                                    builder: (_, _) => Opacity(
                                      opacity: _pulseOpacity.value,
                                      child: Transform.scale(
                                        scale: _pulseScale.value,
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
                                  if (!_exiting)
                                    AnimatedBuilder(
                                      animation: _riderController,
                                      builder: (_, _) {
                                        final t = _riderController.value;
                                        if (t >= 1) {
                                          return const SizedBox.shrink();
                                        }
                                        return Positioned(
                                          right: sw * 0.5 -
                                              sw * (1 - t) * 0.5 +
                                              60,
                                          child: Opacity(
                                            opacity: (1 - t).clamp(0, 1),
                                            child: const _SpeedLines(),
                                          ),
                                        );
                                      },
                                    ),
                                  AnimatedBuilder(
                                    animation: Listenable.merge([
                                      _riderController,
                                      _exitController,
                                    ]),
                                    builder: (_, _) {
                                      final enterOffset =
                                          -(sw + 100) * (1 - _riderX.value);
                                      final exitOffset =
                                          (sw + 100) * _exitX.value;

                                      return Transform.translate(
                                        offset: Offset(
                                          enterOffset + exitOffset,
                                          _riderY.value,
                                        ),
                                        child: Opacity(
                                          opacity: _riderOpacity.value,
                                          child: const _RiderCard(),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 28),
                            FadeTransition(
                              opacity: _uiOpacity,
                              child: Column(
                                children: [
                                  _buildChip(),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'سائقين بخطوة\nتوصيل أسرع من خيالك',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      height: 1.45,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'وصّل أكلك من أقرب المطاعم في دقائق',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.65,
                                      ),
                                      fontSize: 14,
                                      height: 1.6,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return AnimatedBuilder(
      animation: _orbController,
      builder: (_, _) {
        final t = _orbController.value * 2 * math.pi;
        return Stack(
          children: [
            Positioned(
              top: 80 + math.sin(t * 0.7) * 8,
              left: -60 + math.cos(t * 0.5) * 6,
              child: _Orb(
                color: Colors.white.withValues(alpha: 0.07),
                diameter: 200,
              ),
            ),
            Positioned(
              right: -40 + math.cos(t * 0.6) * 7,
              bottom: 160 + math.sin(t * 0.8) * 9,
              child: _Orb(
                color: Colors.white.withValues(alpha: 0.05),
                diameter: 140,
              ),
            ),
            Positioned(
              top: 30 + math.sin(t * 0.4) * 5,
              right: 30 + math.cos(t * 0.9) * 5,
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
      },
    );
  }

  Widget _buildGroundShadow() {
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

  Widget _buildChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFF4ADE80),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          const Text(
            'توصيل سريع الآن',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
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
