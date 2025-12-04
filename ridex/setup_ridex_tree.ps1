# Write-Host "Setting up folders and empty Dart files for RideX..."

# $folders = @(
#   "lib/core/router",
#   "lib/core/theme",
#   "lib/core/localization",
#   "lib/core/widgets",

#   "lib/common/providers",

#   "lib/features/auth/domain/entities",
#   "lib/features/auth/domain/value_objects",
#   "lib/features/auth/data/repositories",
#   "lib/features/auth/data/datasources",
#   "lib/features/auth/presentation/screens",
#   "lib/features/auth/presentation/providers",

#   "lib/features/home/domain",
#   "lib/features/home/data",
#   "lib/features/home/presentation/screens",
#   "lib/features/home/presentation/providers",
#   "lib/features/home/presentation/widgets",

#   "lib/features/ride/domain",
#   "lib/features/ride/data",
#   "lib/features/ride/presentation/screens",
#   "lib/features/ride/presentation/providers",
#   "lib/features/ride/presentation/widgets",

#   "lib/features/rides_history/domain",
#   "lib/features/rides_history/data",
#   "lib/features/rides_history/presentation/screens",
#   "lib/features/rides_history/presentation/providers",

#   "lib/features/profile/domain",
#   "lib/features/profile/data",
#   "lib/features/profile/presentation/screens",
#   "lib/features/profile/presentation/providers"
# )

# foreach ($folder in $folders) {
#   New-Item -ItemType Directory -Force -Path $folder | Out-Null
# }

# Write-Host "Folders created."

# $files = @(
#   "lib/core/router/app_router.dart",
#   "lib/core/theme/app_colors.dart",
#   "lib/core/theme/app_theme.dart",
#   "lib/core/localization/app_localizations.dart",
#   "lib/core/localization/supported_locales.dart",
#   "lib/core/widgets/primary_button.dart",
#   "lib/core/widgets/secondary_button.dart",
#   "lib/core/widgets/app_text_field.dart",
#   "lib/core/widgets/bottom_sheet_container.dart",

#   "lib/common/providers/global_providers.dart",

#   "lib/features/auth/presentation/providers/auth_providers.dart",
#   "lib/features/auth/presentation/screens/splash_welcome_screen.dart",
#   "lib/features/auth/presentation/screens/onboarding_carousel_screen.dart",
#   "lib/features/auth/presentation/screens/create_account_screen.dart",
#   "lib/features/auth/presentation/screens/register_phone_screen.dart",
#   "lib/features/auth/presentation/screens/register_otp_screen.dart",
#   "lib/features/auth/presentation/screens/location_permission_screen.dart",
#   "lib/features/auth/presentation/screens/privacy_policy_screen.dart",
#   "lib/features/auth/presentation/screens/login_screen.dart",
#   "lib/features/auth/presentation/screens/forgot_password_phone_screen.dart",
#   "lib/features/auth/presentation/screens/forgot_password_otp_screen.dart",
#   "lib/features/auth/presentation/screens/reset_password_screen.dart",

#   "lib/features/home/presentation/providers/home_providers.dart",
#   "lib/features/home/presentation/screens/home_map_screen.dart",
#   "lib/features/home/presentation/screens/schedule_time_screen.dart",
#   "lib/features/home/presentation/screens/schedule_date_screen.dart",
#   "lib/features/home/presentation/widgets/location_search_panel.dart",
#   "lib/features/home/presentation/widgets/not_found_panel.dart",
#   "lib/features/home/presentation/widgets/confirm_destination_panel.dart",
#   "lib/features/home/presentation/widgets/ride_options_sheet.dart",
#   "lib/features/home/presentation/widgets/offer_price_sheet.dart",

#   "lib/features/ride/presentation/providers/ride_providers.dart",
#   "lib/features/ride/presentation/screens/finding_driver_screen.dart",
#   "lib/features/ride/presentation/screens/no_drivers_screen.dart",
#   "lib/features/ride/presentation/screens/ride_in_progress_screen.dart",
#   "lib/features/ride/presentation/screens/ride_completed_screen.dart",
#   "lib/features/ride/presentation/screens/feedback_thanks_screen.dart",
#   "lib/features/ride/presentation/screens/call_screen.dart",
#   "lib/features/ride/presentation/screens/chat_with_driver_screen.dart",
#   "lib/features/ride/presentation/widgets/cancel_ride_sheet.dart",
#   "lib/features/ride/presentation/widgets/driver_status_card.dart",

#   "lib/features/rides_history/presentation/providers/rides_history_providers.dart",
#   "lib/features/rides_history/presentation/screens/rides_screen.dart",
#   "lib/features/rides_history/presentation/screens/ride_help_screen.dart",
#   "lib/features/rides_history/presentation/screens/ride_issue_list_screen.dart",
#   "lib/features/rides_history/presentation/screens/ride_issue_detail_screen.dart",

#   "lib/features/profile/presentation/providers/profile_providers.dart",
#   "lib/features/profile/presentation/screens/profile_screen.dart",
#   "lib/features/profile/presentation/screens/services_screen.dart",
#   "lib/features/profile/presentation/screens/payment_screen.dart"
# )

# foreach ($file in $files) {
#   if (-not (Test-Path $file)) {
#     New-Item -ItemType File -Force -Path $file | Out-Null
#   }
# }

# Write-Host "Project structure is ready."
