import 'package:flutter/material.dart';

import '../modules/auth/login/views/login_screen.dart';
import '../modules/home/views/home_preview_screen.dart';
import 'theme/app_colors.dart';
import '../modules/onboarding/views/intro_flow_screen.dart';

class RideXApp extends StatelessWidget {
  const RideXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RideX',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
        ),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'sans-serif',
      ),
      routes: {
        '/home': (_) => const HomePreviewScreen(),
        '/login': (_) => const LoginScreen(),
      },
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: IntroFlowScreen(),
      ),
    );
  }
}
