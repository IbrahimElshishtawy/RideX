import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController
    with GetTickerProviderStateMixin {
  late final AnimationController riderController;
  late final Animation<double> riderX;
  late final Animation<double> riderY;
  late final Animation<double> riderOpacity;

  late final AnimationController exitController;
  late final Animation<double> exitX;

  late final AnimationController uiFadeController;
  late final Animation<double> uiOpacity;

  late final AnimationController pulseController;
  late final Animation<double> pulseScale;
  late final Animation<double> pulseOpacity;

  late final AnimationController orbController;

  final RxBool exiting = false.obs;

  @override
  void onInit() {
    super.onInit();

    riderController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    riderX = CurvedAnimation(
      parent: riderController,
      curve: Curves.easeOutCubic,
    );
    riderY = TweenSequence<double>([
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
    ]).animate(riderController);
    riderOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: riderController,
        curve: const Interval(0, 0.3, curve: Curves.easeIn),
      ),
    );

    uiFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    uiOpacity = CurvedAnimation(
      parent: uiFadeController,
      curve: Curves.easeInOut,
    );

    pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    pulseScale = Tween<double>(
      begin: 0.6,
      end: 2.2,
    ).animate(CurvedAnimation(parent: pulseController, curve: Curves.easeOut));
    pulseOpacity = Tween<double>(
      begin: 0.55,
      end: 0.0,
    ).animate(CurvedAnimation(parent: pulseController, curve: Curves.easeOut));

    orbController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    exitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 820),
    );
    exitX = CurvedAnimation(
      parent: exitController,
      curve: Curves.easeInCubic,
    );

    _runSequence();
  }

  Future<void> _runSequence() async {
    await Future.delayed(const Duration(milliseconds: 200));
    uiFadeController.forward();
    await riderController.forward();
    pulseController.repeat();
    await Future.delayed(const Duration(milliseconds: 2000));
    pulseController.stop();
    exiting.value = true;
    await exitController.forward();

    if (Get.isRegistered<OnboardingController>()) {
      Get.offNamed('/home');
    }
  }

  double orbPhase() => orbController.value * 2 * math.pi;

  @override
  void onClose() {
    riderController.dispose();
    exitController.dispose();
    uiFadeController.dispose();
    pulseController.dispose();
    orbController.dispose();
    super.onClose();
  }
}
