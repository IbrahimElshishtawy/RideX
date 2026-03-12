import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../app/theme/app_colors.dart';

// ─────────────────────────────────────────────
// ENTRY POINT – replace your old file with this
// ─────────────────────────────────────────────
class OnboardingDeliveryView extends StatefulWidget {
  const OnboardingDeliveryView({super.key});

  @override
  State<OnboardingDeliveryView> createState() => _OnboardingDeliveryViewState();
}

class _OnboardingDeliveryViewState extends State<OnboardingDeliveryView>
    with TickerProviderStateMixin {
  // ── Rider slide-in (left → center) ──
  late final AnimationController _riderController;
  late final Animation<double> _riderX; // 0 = off-screen left, 1 = center
  late final Animation<double> _riderY; // subtle bounce on arrive
  late final Animation<double> _riderOpacity;

  // ── Rider slide-out (center → right) ──
  late final AnimationController _exitController;
  late final Animation<double> _exitX; // 1 = center, 0 = off-screen right

  // ── UI fade-in (text, orbs, etc.) ──
  late final AnimationController _uiFadeController;
  late final Animation<double> _uiOpacity;

  // ── Pulse ring on arrive ──
  late final AnimationController _pulseController;
  late final Animation<double> _pulseScale;
  late final Animation<double> _pulseOpacity;

  // ── Parallax orbs idle float ──
  late final AnimationController _orbController;

  bool _exiting = false;

  @override
  void initState() {
    super.initState();

    // 1. Rider enter  (0 ms → 900 ms)
    _riderController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _riderX = CurvedAnimation(
      parent: _riderController,
      curve: Curves.easeOutCubic,
    );
    _riderY = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -14), weight: 60),
      TweenSequenceItem(
        tween: Tween(begin: , end: ).chain(CurveTween(curve: Curves.bounceOut)),
        weight: 40,
      
      ),
    ]).animate(_riderController);
    _riderOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _riderController,
        curve: const Interval(0, 0.3, curve: Curves.easeIn),
      ),
    );

    // 2. UI elements fade-in (starts with rider)
    _uiFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _uiOpacity = CurvedAnimation(
      parent: _uiFadeController,
      curve: Curves.easeInOut,
    );

    // 3. Pulse ring (loops while waiting)
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

    // 4. Orb idle float (loops forever)
    _orbController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    // 5. Rider exit  (center → right)
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
    // tiny initial pause
    await Future.delayed(const Duration(milliseconds: 200));

    // fade in UI + rider enter simultaneously
    _uiFadeController.forward();
    await _riderController.forward();

    // hold for 2 seconds, pulse ring loops
    _pulseController.repeat();
    await Future.delayed(const Duration(milliseconds: 2000));
    _pulseController.stop();

    // exit
    setState(() => _exiting = true);
    await _exitController.forward();

    // navigate to login
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/login');
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
    final sw = MediaQuery.of(context).size.width;

    return Container(
      color: AppColors.primary,
      child: SafeArea(
        child: Stack(
          children: [
            // ── Background decorations ──
            _buildBackground(),

            // ── Main content ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // ── Stage: pulse + rider ──
                  SizedBox(
                    height: 220,
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        // Ground shadow
                        Positioned(bottom: 12, child: _buildGroundShadow()),

                        // Pulse ring
                        AnimatedBuilder(
                          animation: _pulseController,
                          builder: (_, __) => Opacity(
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

                        // Speed lines (visible only while moving)
                        if (!_exiting)
                          AnimatedBuilder(
                            animation: _riderController,
                            builder: (_, __) {
                              final t = _riderController.value;
                              if (t >= 1) return const SizedBox.shrink();
                              return Positioned(
                                right: sw * 0.5 - sw * (1 - t) * 0.5 + 60,
                                child: Opacity(
                                  opacity: (1 - t).clamp(0, 1),
                                  child: _SpeedLines(),
                                ),
                              );
                            },
                          ),

                        // ── THE RIDER ──
                        AnimatedBuilder(
                          animation: Listenable.merge([
                            _riderController,
                            _exitController,
                          ]),
                          builder: (_, __) {
                            // Enter: slide from -sw to 0
                            final enterOffset =
                                -(sw + 100) * (1 - _riderX.value);
                            // Exit: slide from 0 to +sw
                            final exitOffset = (sw + 100) * _exitX.value;

                            return Transform.translate(
                              offset: Offset(
                                enterOffset + exitOffset,
                                _riderY.value,
                              ),
                              child: Opacity(
                                opacity: _riderOpacity.value,
                                child: _RiderCard(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Text block ──
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
                            color: Colors.white.withValues(alpha: 0.65),
                            fontSize: 14,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(flex: 3),

                  // ── Progress dots ──
                  FadeTransition(
                    opacity: _uiOpacity,
                    child: _ProgressDots(activeIndex: 0, count: 3),
                  ),
                  const SizedBox(height: 12),
                  const HomeIndicator(),
                  const SizedBox(height: 10),
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
      builder: (_, __) {
        final t = _orbController.value * 2 * math.pi;
        return Stack(
          children: [
            // Top-left large orb
            Positioned(
              top: 80 + math.sin(t * 0.7) * 8,
              left: -60 + math.cos(t * 0.5) * 6,
              child: _Orb(
                color: Colors.white.withValues(alpha: 0.07),
                diameter: 200,
              ),
            ),
            // Bottom-right medium orb
            Positioned(
              right: -40 + math.cos(t * 0.6) * 7,
              bottom: 160 + math.sin(t * 0.8) * 9,
              child: _Orb(
                color: Colors.white.withValues(alpha: 0.05),
                diameter: 140,
              ),
            ),
            // Subtle top-right tiny orb
            Positioned(
              top: 30 + math.sin(t * 0.4) * 5,
              right: 30 + math.cos(t * 0.9) * 5,
              child: _Orb(
                color: Colors.white.withValues(alpha: 0.08),
                diameter: 60,
              ),
            ),
            // Bottom center large glow
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
      width: 140,
      height: 16,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
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

// ─────────────────────────────────
// Rider card widget
// ─────────────────────────────────
class _RiderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      clipBehavior: Clip.none,
      children: [
        // Card glow / halo
        Container(
          width: 170,
          height: 170,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.08),
          ),
        ),
        // Lottie
        SizedBox(
          width: 170,
          height: 170,
          child: Lottie.asset(
            'assets/lolltie/Delivery guy.json',
            repeat: true,
            fit: BoxFit.contain,
          ),
        ),
        // ETA badge
        Positioned(top: -8, right: -8, child: _EtaBadge()),
      ],
    );
  }
}

// ─────────────────────────────────
// ETA badge
// ─────────────────────────────────
class _EtaBadge extends StatelessWidget {
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
          Icon(Icons.access_time_rounded, size: 12, color: AppColors.primary),
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

// ─────────────────────────────────
// Speed lines
// ─────────────────────────────────
class _SpeedLines extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _line(60),
        const SizedBox(height: 7),
        _line(38),
        const SizedBox(height: 7),
        _line(50),
      ],
    );
  }

  Widget _line(double w) => Container(
    width: w,
    height: 3,
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.25),
      borderRadius: BorderRadius.circular(999),
    ),
  );
}

// ─────────────────────────────────
// Progress dots
// ─────────────────────────────────
class _ProgressDots extends StatelessWidget {
  final int activeIndex;
  final int count;
  const _ProgressDots({required this.activeIndex, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (i) {
        final active = i == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: active ? 22 : 7,
          height: 7,
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.white.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────
// Orb
// ─────────────────────────────────
class _Orb extends StatelessWidget {
  final Color color;
  final double diameter;
  const _Orb({required this.color, required this.diameter});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

// ─────────────────────────────────
// Home indicator bar
// ─────────────────────────────────
class HomeIndicator extends StatelessWidget {
  const HomeIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 86,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}
