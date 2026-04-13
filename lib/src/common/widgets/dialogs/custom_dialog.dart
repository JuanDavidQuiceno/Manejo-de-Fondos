import 'package:dashboard/src/common/services/responsive_content.dart';
import 'package:dashboard/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Muestra un diálogo con restricciones genéricas y opciones de
/// personalización.
///
/// [child]: contenido del diálogo (ej. modales de selección, formularios).
/// [barrierDismissible]: si false, no se cierra al tocar fuera (default false).
/// [maxWidthMobile]: ancho máximo en móvil; null = sin límite.
/// [maxWidthDesktop]: ancho máximo en desktop; default 560.
/// [maxHeight]: alto máximo; null = alto de la pantalla.
/// [contentPadding]: padding interno alrededor del [child].
/// [shape]: forma/borde del diálogo.
/// [backgroundColor]: color de fondo.
/// [insetPadding]: espacio mínimo entre el diálogo y los bordes de la pantalla.
/// [elevation]: elevación de la sombra.
/// [clipBehavior]: comportamiento de recorte.
/// [alignment]: alineación del diálogo en pantalla.
Future<T?> showCustomDialog<T>(
  BuildContext context, {
  required Widget child,
  bool barrierDismissible = false,
  double? maxWidthMobile,
  double? maxWidthDesktop = 560,
  double? maxHeight,
  EdgeInsets? contentPadding = const EdgeInsets.all(16),
  ShapeBorder? shape,
  Color? backgroundColor,
  EdgeInsets? insetPadding,
  double? elevation,
  Clip clipBehavior = Clip.none,
  AlignmentGeometry alignment = Alignment.center,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (dialogContext) {
      final isMobile = Responsive.isMobile(dialogContext);
      final screenHeight = MediaQuery.sizeOf(dialogContext).height;
      final maxW = isMobile
          ? (maxWidthMobile ?? double.infinity)
          : (maxWidthDesktop ?? 560);
      final maxH = maxHeight ?? screenHeight;

      final constrainedChild = ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxW, maxHeight: maxH),
        child: contentPadding != null
            ? Padding(padding: contentPadding, child: child)
            : child,
      );

      return Dialog(
        backgroundColor:
            backgroundColor ??
            Theme.of(dialogContext).extension<AppColorsExtension>()?.card ??
            Theme.of(dialogContext).dialogTheme.backgroundColor,
        elevation: elevation,
        insetPadding: insetPadding,
        clipBehavior: clipBehavior,
        alignment: alignment,
        shape: shape,
        child: constrainedChild,
      );
    },
  );
}
