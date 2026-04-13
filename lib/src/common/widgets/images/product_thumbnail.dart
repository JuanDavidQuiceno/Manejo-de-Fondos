import 'package:dashboard/src/common/widgets/images/custom_image.dart';
import 'package:dashboard/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Widget reutilizable que muestra la imagen de un producto o un placeholder.
///
/// Si [imageUrl] es válida, muestra la imagen con [CustomImage].
/// Si no, muestra un contenedor gris con un ícono de imagen.
class ProductThumbnail extends StatelessWidget {
  const ProductThumbnail({
    this.imageUrl,
    this.size = 44,
    this.borderRadius = 8,
    super.key,
  });

  /// URL de la imagen. Si es null o vacía, se muestra el placeholder.
  final String? imageUrl;

  /// Ancho y alto del thumbnail (cuadrado).
  final double size;

  /// Radio de las esquinas.
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CustomImage(
        imageUrl!,
        width: size,
        height: size,
        borderRadius: BorderRadius.circular(borderRadius),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.grey,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: const Icon(Icons.image, color: AppColors.white),
    );
  }
}
