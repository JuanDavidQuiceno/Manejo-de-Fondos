import 'package:dashboard/src/common/services/responsive_content.dart';
import 'package:flutter/material.dart';

/// Muestra un diálogo con restricciones genéricas (ancho según responsive,
/// alto máximo según pantalla). Reutilizable para modales de selección, etc.
///
/// [child]: contenido del diálogo (ej. modales de selección de rol, estado).
/// [barrierDismissible]: si false, no se cierra al tocar fuera (default false).
/// [maxWidthMobile]: ancho máximo en móvil; null = sin límite
/// (double.infinity).
/// [maxWidthDesktop]: ancho máximo en desktop; null = 560.
/// [maxHeight]: alto máximo; null = alto de la pantalla.
Future<T?> showAppDialog<T>(
  BuildContext context, {
  required Widget child,
  bool barrierDismissible = false,
  double? maxWidthMobile,
  double? maxWidthDesktop = 560,
  double? maxHeight,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (dialogContext) {
      final isMobile = Responsive.isMobile(dialogContext);
      final screenHeight = MediaQuery.sizeOf(dialogContext).height;
      return Dialog(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isMobile
                ? (maxWidthMobile ?? double.infinity)
                : maxWidthDesktop!,
            maxHeight: maxHeight ?? screenHeight,
          ),
          child: child,
        ),
      );
    },
  );
}
