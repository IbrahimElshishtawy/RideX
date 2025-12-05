// ignore_for_file: dead_code

import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppStartDestination { onboarding, login, home }

final appStartDestinationProvider = FutureProvider<AppStartDestination>((
  ref,
) async {
  await Future.delayed(const Duration(milliseconds: 500));
  bool userSeenOnboarding = false;
  bool userLoggedIn = false;

  if (!userSeenOnboarding) {
    return AppStartDestination.onboarding;
  }

  if (!userLoggedIn) {
    return AppStartDestination.login;
  }

  return AppStartDestination.home;
});
