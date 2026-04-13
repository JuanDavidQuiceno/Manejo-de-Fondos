import 'package:dashboard/src/common/widgets/buttons/custom_button_v2.dart';
import 'package:dashboard/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum AlertType { success, error, warning, info, none }

class CustomAlert {
  static Future<bool> dialog(
    BuildContext context, {
    AlertType? type = AlertType.none,
    String? title,
    String? message,
    String? textButton,
    VoidCallback? onPressed,
    String? textButtomCancel,
    VoidCallback? onPressedCancel,
    Color? colorButtonCancel,
  }) async {
    return showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const SizedBox.shrink();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );

        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1).animate(curvedAnimation),
          child: FadeTransition(
            opacity: animation,
            child: _ModernAlertContent(
              type: type ?? AlertType.none,
              title: title,
              message: message,
              textButton: textButton,
              onPressed: onPressed,
              textButtonCancel: textButtomCancel,
              onPressedCancel: onPressedCancel,
            ),
          ),
        );
      },
    ).then((value) => value ?? false);
  }

  // showSnackBar
  static void showSnackBar(
    BuildContext context, {
    String? title,
    String? message,
    String? textButton,
    VoidCallback? onPressed,
  }) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message ?? 'Error'),
        action: onPressed != null
            ? SnackBarAction(
                label: textButton ?? 'Aceptar',
                onPressed: onPressed,
              )
            : null,
      ),
    );
  }
}

class _ModernAlertContent extends StatelessWidget {
  const _ModernAlertContent({
    required this.type,
    this.title,
    this.message,
    this.textButton,
    this.onPressed,
    this.textButtonCancel,
    this.onPressedCancel,
  });

  final AlertType type;
  final String? title;
  final String? message;
  final String? textButton;
  final VoidCallback? onPressed;
  final String? textButtonCancel;
  final VoidCallback? onPressedCancel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color:
              theme.extension<AppColorsExtension>()?.card ??
              colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(25),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 40,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Close button
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, right: 8),
                    child: IconButton(
                      onPressed: () => context.pop(false),
                      icon: Icon(
                        Icons.close_rounded,
                        color: colorScheme.onSurface.withAlpha(150),
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: colorScheme.onSurface.withAlpha(20),
                        padding: const EdgeInsets.all(8),
                      ),
                    ),
                  ),
                ),

                // Icon with colored background
                if (type != AlertType.none) _buildIconSection(),

                const SizedBox(height: 16),

                // Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    title ?? _getDefaultTitle(),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 12),

                // Message
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    message ?? '',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withAlpha(180),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 28),

                // Buttons
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: _buildButtons(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconSection() {
    final iconData = _getIconData();
    final colors = _getAlertColors();

    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: colors.iconColor.withAlpha(40),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(iconData, size: 36, color: colors.iconColor),
    );
  }

  Widget _buildButtons(BuildContext context) {
    final hasCancel = onPressedCancel != null;
    final buttonColor = _getButtonColor();

    return OverflowBar(
      alignment: MainAxisAlignment.end,
      spacing: 12,
      overflowSpacing: 12,
      children: [
        if (hasCancel)
          CustomButtonV2(
            text: textButtonCancel ?? 'Cancelar',
            onPressed: () {
              context.pop(false);
              onPressedCancel?.call();
            },
            backgroundColor: Theme.of(
              context,
            ).colorScheme.onSurface.withAlpha(150),
            isOutlined: true,
          ),
        CustomButtonV2(
          text: textButton ?? 'Aceptar',
          onPressed: () {
            context.pop(true);
            onPressed?.call();
          },
          backgroundColor: buttonColor,
        ),
      ],
    );
  }

  IconData _getIconData() {
    return switch (type) {
      AlertType.success => Icons.check_circle_rounded,
      AlertType.error => Icons.error_rounded,
      AlertType.warning => Icons.warning_rounded,
      AlertType.info => Icons.info_rounded,
      AlertType.none => Icons.info_rounded,
    };
  }

  String _getDefaultTitle() {
    return switch (type) {
      AlertType.success => 'Exitoso',
      AlertType.error => 'Error',
      AlertType.warning => 'Advertencia',
      AlertType.info => 'Informacion',
      AlertType.none => 'Aviso',
    };
  }

  Color _getButtonColor() {
    return switch (type) {
      AlertType.success => AppColors.success,
      AlertType.error => AppColors.error,
      AlertType.warning => AppColors.warning,
      AlertType.info => AppColors.primary,
      AlertType.none => AppColors.primary,
    };
  }

  ({Color iconColor, Color backgroundColor}) _getAlertColors() {
    return switch (type) {
      AlertType.success => (
        iconColor: AppColors.success,
        backgroundColor: AppColors.success.withAlpha(25),
      ),
      AlertType.error => (
        iconColor: AppColors.error,
        backgroundColor: AppColors.error.withAlpha(25),
      ),
      AlertType.warning => (
        iconColor: AppColors.warning,
        backgroundColor: AppColors.warning.withAlpha(25),
      ),
      AlertType.info => (
        iconColor: AppColors.primary,
        backgroundColor: AppColors.primary.withAlpha(25),
      ),
      AlertType.none => (
        iconColor: AppColors.primary,
        backgroundColor: AppColors.primary.withAlpha(25),
      ),
    };
  }
}
