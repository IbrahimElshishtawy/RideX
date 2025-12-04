Write-Host "Generating core widgets for RideX..."

function Write-File($path, $content) {
    $folder = Split-Path $path
    if (-not (Test-Path $folder)) {
        New-Item -ItemType Directory -Force -Path $folder | Out-Null
    }
    Set-Content -Path $path -Value $content -Encoding UTF8
}

# -------------------------------------------------------
# PrimaryButton
# -------------------------------------------------------
$primaryButton = @"
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool disabled;
  final double radius;
  final double height;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.disabled = false,
    this.radius = 12,
    this.height = 52,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: disabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: disabled
              ? theme.colorScheme.primary.withOpacity(0.4)
              : theme.colorScheme.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
"@

Write-File "lib/core/widgets/primary_button.dart" $primaryButton

# -------------------------------------------------------
# SecondaryButton
# -------------------------------------------------------
$secondaryButton = @"
import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double radius;
  final double height;

  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.radius = 12,
    this.height = 52,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: theme.colorScheme.primary, width: 1.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: theme.colorScheme.primary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
"@

Write-File "lib/core/widgets/secondary_button.dart" $secondaryButton

# -------------------------------------------------------
# AppTextField
# -------------------------------------------------------
$appTextField = @"
import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String? hint;
  final bool obscure;
  final TextInputType keyboard;
  final Widget? prefix;
  final Widget? suffix;

  const AppTextField({
    super.key,
    this.controller,
    required this.label,
    this.hint,
    this.obscure = false,
    this.keyboard = TextInputType.text,
    this.prefix,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefix,
        suffixIcon: suffix,
        filled: true,
        fillColor: theme.colorScheme.surface.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: theme.dividerColor.withOpacity(0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: theme.colorScheme.primary,
            width: 1.4,
          ),
        ),
      ),
    );
  }
}
"@

Write-File "lib/core/widgets/app_text_field.dart" $appTextField

# -------------------------------------------------------
# BottomSheetContainer
# -------------------------------------------------------
$bottomSheetContainer = @"
import 'package:flutter/material.dart';

class BottomSheetContainer extends StatelessWidget {
  final Widget child;
  final double radius;
  final EdgeInsets padding;

  const BottomSheetContainer({
    super.key,
    required this.child,
    this.radius = 22,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(radius)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 12,
            offset: Offset(0, -3),
          ),
        ],
      ),
      padding: padding,
      child: child,
    );
  }
}
"@

Write-File "lib/core/widgets/bottom_sheet_container.dart" $bottomSheetContainer

# -------------------------------------------------------
# SectionTitle
# -------------------------------------------------------
$sectionTitle = @"
import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String text;

  const SectionTitle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
"@

Write-File "lib/core/widgets/section_title.dart" $sectionTitle

# -------------------------------------------------------
# RideCard
# -------------------------------------------------------
$rideCard = @"
import 'package:flutter/material.dart';

class RideCard extends StatelessWidget {
  final String driverName;
  final String vehicleName;
  final String plate;
  final double rating;
  final String? image;

  const RideCard({
    super.key,
    required this.driverName,
    required this.vehicleName,
    required this.plate,
    required this.rating,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.08),
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: image != null ? AssetImage(image!) : null,
            child: image == null ? const Icon(Icons.person) : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  driverName,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "$vehicleName • $plate",
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text(rating.toStringAsFixed(1)),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
"@

Write-File "lib/features/ride/presentation/widgets/driver_status_card.dart" $rideCard

Write-Host "All widget files created successfully."
