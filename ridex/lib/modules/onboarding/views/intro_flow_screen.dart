import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/onboarding_controller.dart';
import 'widgets/onboarding_widgets.dart';

class IntroFlowScreen extends GetView<OnboardingController> {
  const IntroFlowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final sw = size.width;

    return Scaffold(
      body: ColoredBox(
        color: const Color(0xFF20B05C),
        child: SafeArea(
          child: Stack(
            children: [
              AnimatedBuilder(
                animation: controller.orbController,
                builder: (_, _) => OnboardingBackground(
                  phase: controller.orbPhase(),
                ),
              ),
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
                              OnboardingHeroStage(screenWidth: sw),
                              const SizedBox(height: 28),
                              const OnboardingTextContent(),
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
      ),
    );
  }
}
