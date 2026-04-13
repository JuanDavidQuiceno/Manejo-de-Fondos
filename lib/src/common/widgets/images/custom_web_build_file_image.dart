import 'package:flutter/material.dart';

/// Esta es la implementación "stub" (de reemplazo) para la web.
/// Tiene la misma firma que la versión móvil, pero no usa `dart:io`.
Widget buildFileImage({
  required String imagePath,
  required bool isSvg,
  required double? height,
  required double? width,
  required BoxFit fit,
  required Color? color,
  required FilterQuality filterQuality,
  required Widget Function() errorBuilder,
  required Widget Function(BuildContext) placeholderBuilder,
}) {
  // Cargar un archivo local no es posible en la web, así que siempre
  //devolvemos el widget de error.
  debugPrint(
    'Attempted to load a local file on web: $imagePath. This is not supported.',
  );
  return errorBuilder();
}
