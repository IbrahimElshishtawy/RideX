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
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const curveColor = Color(0xFFE6E4FA);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ==================== IMAGE AREA (FIXED BACKGROUND: WHITE) ====================
            Expanded(
              flex: 6,
              child: Container(
                width: double.infinity,

                color: Colors.white,

                child: PageView.builder(
                  controller: _controller,
                  itemCount: items.length,
                  onPageChanged: (i) => setState(() => _index = i),
                  itemBuilder: (context, i) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        image: DecorationImage(
                          image: AssetImage(items[i].image),
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 10),

            // ==================== FIXED INDICATORS (لا تتحرك مع الصور) ====================
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                items.length,
                (dotIndex) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _index == dotIndex ? 10 : 6,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _index == dotIndex
                        ? theme.colorScheme.primary
                        : theme.colorScheme.primary.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // ==================== CURVED BOTTOM SECTION ====================
            Expanded(
              flex: 5,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: curveColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(300),
                        topRight: Radius.circular(300),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 60,
                    left: 20,
                    right: 20,
                    child: Column(
                      children: [
                        const SizedBox(height: 27),
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
                            fontSize: 15,
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Positioned(
                    bottom: 40,
                    left: 24,
                    right: 24,
                    child: SizedBox(
                      height: 52,
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
