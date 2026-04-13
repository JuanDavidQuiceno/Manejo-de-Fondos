import 'package:dashboard/src/core/theme/app_colors.dart';
import 'package:dashboard/src/core/theme/extensions/text_theme_extension.dart';
import 'package:flutter/material.dart';

/// Placeholder Screen for tabs not yet implemented
///
/// Shows a simple placeholder UI with the tab name.
/// Replace with actual screen implementation when ready.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({
    required this.title,
    this.icon = Icons.construction,
    super.key,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 64, color: AppColors.gray400),
              const SizedBox(height: 16),
              Text(
                title,
                style: context.headingMedium.copyWith(color: AppColors.gray600),
              ),
              const SizedBox(height: 8),
              Text(
                'Coming soon',
                style: context.bodyMedium.copyWith(color: AppColors.gray400),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
