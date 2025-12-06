// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ridex/features/auth/data/models/OnboardingModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingCarouselScreen extends ConsumerStatefulWidget {
  const OnboardingCarouselScreen({super.key});

  @override
  ConsumerState<OnboardingCarouselScreen> createState() =>
      _OnboardingCarouselScreenState();
}

class _OnboardingCarouselScreenState
    extends ConsumerState<OnboardingCarouselScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  final List<OnboardingModel> items = const [
    OnboardingModel(
      title: "Fast & Easy Rides",
      desc: "Book your ride in seconds with a few taps anytime anywhere",
      image: "assets/image/onboarding1.png",
    ),
    OnboardingModel(
      title: "Real Drivers",
      desc:
          "Easily connect with nearby drivers and track your ride live on the map",
      image: "assets/image/onboarding2.png",
    ),
    OnboardingModel(
      title: "Fair Pricing",
      desc: "Get instant fare suggestions powered by AI and pay your way",
      image: "assets/image/onboarding3.png",
    ),
  ];

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("seen_onboarding", true);
    if (!mounted) return;
    context.go("/login");
  }

  void _next() {
    if (_index == items.length - 1) {
      _completeOnboarding();
    } else {
      _controller.animateToPage(
        _index + 1,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // -------- IMAGE AREA --------
            Expanded(
              flex: 6,
              child: PageView.builder(
                controller: _controller,
                itemCount: items.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Image.asset(items[i].image, fit: BoxFit.contain),
                  );
                },
              ),
            ),

            // -------- CURVED WHITE AREA --------
            Expanded(
              flex: 7,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  // الخلفية Curve
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(200),
                        topRight: Radius.circular(200),
                      ),
                    ),
                  ),

                  // Indicators
                  Positioned(
                    top: 30,
                    child: Row(
                      children: List.generate(
                        items.length,
                        (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _index == i ? 12 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: _index == i
                                ? theme.colorScheme.primary
                                : theme.colorScheme.primary.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // TEXT CONTENT
                  Positioned(
                    top: 80,
                    left: 25,
                    right: 25,
                    child: Column(
                      children: [
                        Text(
                          items[_index].title,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          items[_index].desc,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // BUTTON
                  Positioned(
                    bottom: 40,
                    left: 24,
                    right: 24,
                    child: SizedBox(
                      height: 54,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _next,
                        child: Text(
                          _index == items.length - 1
                              ? "CREATE ACCOUNT"
                              : "NEXT",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
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
}
