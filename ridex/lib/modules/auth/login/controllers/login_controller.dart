import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController with GetTickerProviderStateMixin {
  late final AnimationController staggerController;
  late final AnimationController orbController;
  late final AnimationController shimmerController;

  static const int itemCount = 7;
  late final List<Animation<double>> fadeAnimations;
  late final List<Animation<Offset>> slideAnimations;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final obscure = true.obs;
  final loading = false.obs;

  @override
  void onInit() {
    super.onInit();

    staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..forward();

    orbController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    fadeAnimations = List.generate(itemCount, (index) {
      final start = index * 0.09;
      final end = (start + 0.35).clamp(0.0, 1.0);
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: staggerController,
          curve: Interval(start, end, curve: Curves.easeOut),
        ),
      );
    });

    slideAnimations = List.generate(itemCount, (index) {
      final start = index * 0.09;
      final end = (start + 0.4).clamp(0.0, 1.0);
      return Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: staggerController,
          curve: Interval(start, end, curve: Curves.easeOutCubic),
        ),
      );
    });
  }

  Widget stagger(int index, Widget child) {
    return FadeTransition(
      opacity: fadeAnimations[index],
      child: SlideTransition(
        position: slideAnimations[index],
        child: child,
      ),
    );
  }

  double orbPhase() => orbController.value * 2 * math.pi;

  void toggleObscure() {
    obscure.value = !obscure.value;
  }

  Future<void> handleLogin() async {
    loading.value = true;
    await Future.delayed(const Duration(milliseconds: 1800));
    loading.value = false;
  }

  void backToRoot() {
    Get.until((route) => route.isFirst);
  }

  @override
  void onClose() {
    staggerController.dispose();
    orbController.dispose();
    shimmerController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
