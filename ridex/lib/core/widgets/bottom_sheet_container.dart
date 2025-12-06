// ignore_for_file: deprecated_member_use

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
