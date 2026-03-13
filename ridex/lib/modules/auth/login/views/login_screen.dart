import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/login_controller.dart';
import 'widgets/login_background.dart';
import 'widgets/login_form_card.dart';
import 'widgets/login_hero_card.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: const Color(0xFFF0F4F2),
          body: Stack(
            children: [
              AnimatedBuilder(
                animation: controller.orbController,
                builder: (_, _) => LoginBackground(
                  phase: controller.orbPhase(),
                ),
              ),
              SafeArea(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 430),
                      child: Column(
                        children: [
                          controller.stagger(
                            0,
                            LoginHeroCard(
                              shimmerController: controller.shimmerController,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const LoginFormCard(),
                          const SizedBox(height: 20),
                          controller.stagger(
                            6,
                            const Text(
                              '© 2025 RideX · جميع الحقوق محفوظة',
                              style: TextStyle(
                                color: Color(0x4A000000),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
