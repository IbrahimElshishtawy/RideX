import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../modules/auth/login/views/login_screen.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_preview_screen.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import 'theme/app_colors.dart';
import '../modules/onboarding/views/intro_flow_screen.dart';

class RideXApp extends StatelessWidget {
  const RideXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
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
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => const Directionality(
            textDirection: TextDirection.rtl,
            child: IntroFlowScreen(),
          ),
          binding: OnboardingBinding(),
        ),
        GetPage(
          name: '/home',
          page: () => const HomePreviewScreen(),
          binding: HomeBinding(),
        ),
        GetPage(
          name: '/login',
          page: () => const LoginScreen(),
        ),
      ],
    );
  }
}
