// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/providers/global_providers.dart';

class SplashWelcomeScreen extends ConsumerStatefulWidget {
  const SplashWelcomeScreen({super.key});

  @override
  ConsumerState<SplashWelcomeScreen> createState() =>
      _SplashWelcomeScreenState();
}

class _SplashWelcomeScreenState extends ConsumerState<SplashWelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();

    // Animation setup
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _scaleAnim = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _fadeAnim = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();
    _decideNavigation();
  }

  Future<void> _decideNavigation() async {
    final dest = await ref.read(appStartDestinationProvider.future).catchError((
      _,
    ) {
      return AppStartDestination.login;
    });

    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;

    switch (dest) {
      case AppStartDestination.onboarding:
        context.go('/onboarding');
        break;
      case AppStartDestination.login:
        context.go('/login');
        break;
      case AppStartDestination.home:
        context.go('/home');
        break;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final appStartAsync = ref.watch(appStartDestinationProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: ScaleTransition(
            scale: _scaleAnim,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // اللوجو
                Container(
                  height: 110,
                  width: 110,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.local_taxi,
                    size: 55,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "RideX",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                // حالة التحميل أو الخطأ
                appStartAsync.when(
                  data: (_) => const SizedBox.shrink(),
                  loading: () => const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  error: (_, _) => Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      'Something went wrong',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
