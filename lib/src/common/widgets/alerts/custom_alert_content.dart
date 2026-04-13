// Archivo: custom_alert_content.dart (o donde lo tengas)

import 'package:dashboard/src/core/theme/extensions/text_theme_extension.dart';
import 'package:flutter/material.dart';

/// Define los tipos de alerta visual.
enum CustomAlertType { success, error, info, warning, custom }

/// Este es el widget visual que representa el contenido de la alerta.
/// Es reutilizable y no sabe nada sobre SnackBars.
class CustomAlertContent extends StatelessWidget {
  /// Un widget de alerta visual que se configura según un [CustomAlertType].
  ///
  /// Si el [type] es [CustomAlertType.custom], debes proporcionar
  /// [icon], [backgroundColor], y [contentColor].
  const CustomAlertContent({
    required this.message,
    this.textStyle,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    this.type = CustomAlertType.info,
    this.border,
    // --- Parámetros para tipo 'custom' ---
    this.iconWidget,
    this.icon,
    this.backgroundColor,
    this.contentColor,
    super.key,
    // Verificación: si es 'custom', asegúrate de que los parámetros no sean
    // nulos
  }) : assert(
         type != CustomAlertType.custom ||
             ((iconWidget != null || icon != null) &&
                 backgroundColor != null &&
                 contentColor != null),
         'Para CustomAlertType.custom, debes proveer (iconWidget o icon), '
         'backgroundColor y contentColor.',
       );
  final String message;
  final TextStyle? textStyle;
  final CustomAlertType type;
  final BoxBorder? border;
  final EdgeInsetsGeometry? padding;

  // Parámetros opcionales, requeridos solo si type == .custom
  final Widget? iconWidget;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? contentColor;

  @override
  Widget build(BuildContext context) {
    // --- Definir colores e ícono según el tipo ---
    late final IconData finalIcon;
    late final Color finalBgColor;
    late final Color finalCtColor;

    switch (type) {
      case CustomAlertType.success:
        finalBgColor = const Color(0xFFE8F5E9); // Verde pastel suave
        finalCtColor = const Color(0xFF2E7D32); // Verde oscuro para contraste
        finalIcon = Icons.check_circle_outline_rounded;
      case CustomAlertType.error:
        finalBgColor = const Color(0xFFFFEBEE); // Rojo pastel suave
        finalCtColor = const Color(0xFFC62828); // Rojo oscuro para contraste
        finalIcon = Icons.error_outline_rounded;
      case CustomAlertType.info:
        finalBgColor = const Color(0xFFE3F2FD); // Azul pastel suave
        finalCtColor = const Color(0xFF1565C0); // Azul oscuro para contraste
        finalIcon = Icons.info_outline_rounded;
      case CustomAlertType.warning:
        finalBgColor = const Color(0xFFFFF8E1); // Ámbar pastel suave
        finalCtColor = const Color(0xFFE65100); // Naranja oscuro para contraste
        finalIcon = Icons.warning_amber_rounded;
      case CustomAlertType.custom:
        // Usa los valores pasados en el constructor (ya validados por el
        // assert)
        finalBgColor = backgroundColor!;
        finalCtColor = contentColor!;
        finalIcon = icon!;
    }

    // --- Construir el widget ---
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: finalBgColor,
        borderRadius: BorderRadius.circular(100), // Píldora
        // Si no se provee un borde, crea uno por defecto con el finalCtColor
        border: border ?? Border.all(color: finalCtColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min, // Para que se ajuste al contenido
        children: [
          if (iconWidget != null) ...[
            iconWidget!,
          ] else ...[
            Icon(finalIcon, color: finalCtColor),
          ],
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              message,
              style:
                  textStyle ?? context.bodyMedium.copyWith(color: finalCtColor),
              // overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
