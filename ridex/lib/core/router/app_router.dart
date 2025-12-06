import 'package:go_router/go_router.dart';
import 'package:ridex/features/auth/presentation/screens/onboarding_carousel_screen.dart';
import 'package:ridex/features/auth/presentation/screens/splash_welcome_screen.dart';

class AppRouter {
  GoRouter get router => _router;

  final GoRouter _router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashWelcomeScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingCarouselScreen(),
      ),
    ],
  );
}
