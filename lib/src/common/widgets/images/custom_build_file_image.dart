import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Implementación para móvil/escritorio que usa `dart:io`
/// para mostrar imágenes de archivos locales.
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
  if (isSvg) {
    return SvgPicture.file(
      File(imagePath),
      height: height,
      width: width,
      fit: fit,
      colorFilter: color != null
          ? ColorFilter.mode(color, BlendMode.srcIn)
          : null,
      placeholderBuilder: placeholderBuilder,
    );
  } else {
    return Image.file(
      File(imagePath),
      height: height,
      width: width,
      fit: fit,
      color: color,
      filterQuality: filterQuality,
      errorBuilder: (context, error, stackTrace) => errorBuilder(),
    );
  }
}
