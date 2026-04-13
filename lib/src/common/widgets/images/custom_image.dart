// Esto elimina dart:io de la web.
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dashboard/src/common/widgets/images/custom_web_build_file_image.dart'
    if (dart.library.html) 'custom_web_build_file_image.dart'
    as file_image_builder;
import 'package:dashboard/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Enum to specify the type of image source.
enum ImageType { file, network, asset }

/// A customizable and efficient widget for displaying images from various
/// sources, with built-in caching for network images.
class CustomImage extends StatelessWidget {
  /// Creates a [CustomImage] widget.
  const CustomImage(
    this.image, {
    super.key,
    this.type,
    this.onTap,
    this.fit = BoxFit.cover,
    this.height,
    this.width,
    this.backgroundColor,
    this.color,
    this.borderRadius = BorderRadius.zero,
    this.boxShadow,
    this.childLoading,
    this.pathLoading,
    this.childNoImage,
    this.pathNoImage,
    this.sizeIconError,
    this.heightLoading,
    this.widthLoading,
    this.strokeWidthLoading,
    this.filterQuality = FilterQuality.medium,
  });

  /// Path, URL, or asset name for the image.
  final String image;

  /// The type of the image source. If null, it will be inferred from the image
  /// string.
  final ImageType? type;

  /// Callback function for when the image is tapped.
  final VoidCallback? onTap;

  /// How the image should be inscribed into the space allocated during layout.
  final BoxFit fit;

  /// The height of the image.
  final double? height;

  /// The width of the image.
  final double? width;

  /// Background color for the container.
  final Color? backgroundColor;

  /// The color to apply to the image as a color filter.
  final Color? color;

  /// The border radius of the image container.
  final BorderRadius borderRadius;

  /// A list of shadows to apply behind the container. If null, no shadow is
  /// applied.
  final List<BoxShadow>? boxShadow;

  /// The widget to be displayed while the main image is loading.
  /// Overrides [pathLoading].
  final Widget? childLoading;

  /// The asset path for an image to display while loading.
  final String? pathLoading;

  /// The widget to be displayed if the main image fails to load.
  /// Overrides [pathNoImage].
  final Widget? childNoImage;

  /// The asset path for an image to display on error.
  final String? pathNoImage;

  /// The size of the default error icon if no other error widget is provided.
  final double? sizeIconError;

  final double? heightLoading;
  final double? widthLoading;
  final double? strokeWidthLoading;

  /// The quality of the image filter.
  final FilterQuality filterQuality;

  // Helper method to determine the image type if not explicitly provided.
  // This centralizes the detection logic.
  ImageType _getEffectiveImageType() {
    if (type != null) {
      return type!;
    }
    if (image.startsWith('http')) {
      return ImageType.network;
    }
    if (image.startsWith('assets/')) {
      return ImageType.asset;
    }
    // Assumes it's a file path if it starts with a slash (common on mobile
    // OSes).
    if (image.startsWith('/')) {
      return ImageType.file;
    }
    // Default fallback, could be adjusted based on your needs.
    return ImageType.asset;
  }

  @override
  Widget build(BuildContext context) {
    // GestureDetector enables the onTap functionality.
    return GestureDetector(
      onTap: onTap,
      // Using a Container is slightly more convenient than a DecoratedBox.
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
          boxShadow: boxShadow,
        ),
        // ClipRRect ensures the image respects the border radius.
        child: ClipRRect(
          borderRadius: borderRadius,
          child: _buildImage(context),
        ),
      ),
    );
  }

  // Central widget builder that uses a switch for better readability.
  Widget _buildImage(BuildContext context) {
    final isSvg = image.toLowerCase().endsWith('.svg');
    final effectiveType = _getEffectiveImageType();

    switch (effectiveType) {
      case ImageType.network:
        return isSvg ? _buildSvgNetwork(context) : _buildRasterNetwork(context);
      case ImageType.file:
        // PASO 2: Ahora llamamos a la función del archivo importado.
        // En web, esta función devolverá un error.
        // En móvil/escritorio, usará dart:io para mostrar la imagen.
        // Esto es 100% seguro porque el código con `File` ya no está en este
        // archivo.
        return file_image_builder.buildFileImage(
          imagePath: image,
          isSvg: isSvg,
          height: height,
          width: width,
          fit: fit,
          color: _getEffectiveColor(context, isSvg: isSvg),
          filterQuality: filterQuality,
          errorBuilder: _buildErrorWidget,
          placeholderBuilder: (_) => _buildLoadingWidget(),
        );
      case ImageType.asset:
        return isSvg ? _buildSvgAsset(context) : _buildRasterAsset(context);
    }
  }

  /// Calculates the effective color based on the user's requested theme logic.
  /// If it's a Raster image (not SVG), we avoid tinting it
  /// by default so photos don't turn grey/black unless explicitly requested.
  Color? _getEffectiveColor(BuildContext context, {required bool isSvg}) {
    // 1. Si enviaron un color directo, forzamos ese color independientemente.
    if (color != null) return color;
    return null;
  }

  // --- Image type specific builders ---

  Widget _buildRasterNetwork(BuildContext context) {
    // implementacion con el paquete de CachedNetworkImage
    return CachedNetworkImage(
      imageUrl: image,
      height: height,
      width: width,
      fit: fit,
      color: _getEffectiveColor(context, isSvg: false),
      // Provides a much cleaner way to handle loading states.
      placeholder: (context, url) => _buildLoadingWidget(),
      // Provides a cleaner way to handle error states.
      errorWidget: (context, url, error) => _buildErrorWidget(),
    );
    // return Image.network(
    //   image,
    //   height: height,
    //   width: width,
    //   fit: fit,
    //   color: color,
    //   filterQuality: filterQuality,
    //   errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
    //   loadingBuilder: (context, child, loadingProgress) {
    //     if (loadingProgress == null) return child;
    //     return _buildLoadingWidget();
    //   },
    // );
  }

  Widget _buildSvgNetwork(BuildContext context) {
    final effectiveColor = _getEffectiveColor(context, isSvg: true);
    return SvgPicture.network(
      image,
      height: height,
      width: width,
      fit: fit,
      colorFilter: effectiveColor != null
          ? ColorFilter.mode(effectiveColor, BlendMode.srcIn)
          : null,
      placeholderBuilder: (context) => _buildLoadingWidget(),
    );
  }

  // Widget _buildRasterFile() {
  //   // Esta línea ahora es SEGURA. Nunca se compilará ni ejecutará en web.
  //   return Image.file(
  //     image,
  //     height: height,
  //     width: width,
  //     fit: fit,
  //     color: color,
  //     filterQuality: filterQuality,
  //     errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
  //   );
  // }

  // Widget _buildSvgFile() {
  //   // Esta línea también es SEGURA.
  //   return SvgPicture.file(
  //     File(image),
  //     height: height,
  //     width: width,
  //     fit: fit,
  //     colorFilter: color != null
  //         ? ColorFilter.mode(color!, BlendMode.srcIn)
  //         : null,
  //     placeholderBuilder: (context) => _buildLoadingWidget(),
  //   );
  // }

  Widget _buildRasterAsset(BuildContext context) {
    return Image.asset(
      image,
      height: height,
      width: width,
      fit: fit,
      color: _getEffectiveColor(context, isSvg: false),
      filterQuality: filterQuality,
      errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
    );
  }

  Widget _buildSvgAsset(BuildContext context) {
    final effectiveColor = _getEffectiveColor(context, isSvg: true);
    return SvgPicture.asset(
      image,
      height: height,
      width: width,
      fit: fit,
      colorFilter: effectiveColor != null
          ? ColorFilter.mode(effectiveColor, BlendMode.srcIn)
          : null,
      placeholderBuilder: (context) => _buildLoadingWidget(),
    );
  }

  // --- Placeholder and Error Widgets ---

  Widget _buildLoadingWidget() {
    if (childLoading != null) return childLoading!;
    if (pathLoading != null) return Image.asset(pathLoading!, fit: fit);
    return Center(
      child: SizedBox(
        width: widthLoading,
        height: heightLoading,
        child: CircularProgressIndicator(strokeWidth: strokeWidthLoading),
      ),
    );
  }

  Widget _buildErrorWidget() {
    if (childNoImage != null) return childNoImage!;
    if (pathNoImage != null) {
      return Image.asset(
        pathNoImage!,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _defaultErrorIcon(),
      );
    }
    return _defaultErrorIcon();
  }

  Widget _defaultErrorIcon() =>
      Icon(Icons.error_outline, size: sizeIconError, color: AppColors.grey);
}
