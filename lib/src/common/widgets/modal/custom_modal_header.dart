import 'package:dashboard/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A centralized and reusable header widget for modals, ensuring consistent
/// styling
/// for the title, optional actions, and the close button.
class CustomModalHeader extends StatelessWidget {
  const CustomModalHeader({
    required this.title,
    this.headerAction,
    this.onClose,
    super.key,
  });

  /// The main title of the modal.
  final String title;

  /// Optional widget placed between the title and the close button
  /// (e.g., a "Create New" button).
  final Widget? headerAction;

  /// Callback when the close button is pressed. If null, `context.pop()` is
  /// used by default.
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 24, top: 24, bottom: 16),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.start,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8, right: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (headerAction != null) ...[
                headerAction!,
                const SizedBox(width: 8),
              ],
              IconButton(
                onPressed: onClose ?? () => context.pop(),
                icon: const Icon(Icons.close_rounded, color: AppColors.gray500),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.gray100,
                  padding: const EdgeInsets.all(8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
