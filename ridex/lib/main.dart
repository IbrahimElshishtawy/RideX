import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ridex/core/router/app_router.dart';
import 'package:ridex/core/theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: RideXApp()));
}

class RideXApp extends ConsumerWidget {
  const RideXApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = AppRouter().router;

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'RideX',

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      routerConfig: router,
    );
  }
}
