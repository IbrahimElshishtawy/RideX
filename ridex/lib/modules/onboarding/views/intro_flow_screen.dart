import 'package:flutter/material.dart';

import 'widgets/onboarding_widgets.dart';

class IntroFlowScreen extends StatelessWidget {
  const IntroFlowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: OnboardingDeliveryView(),
    );
  }
}
