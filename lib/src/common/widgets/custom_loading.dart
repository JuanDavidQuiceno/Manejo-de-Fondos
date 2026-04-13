import 'package:dashboard/src/common/services/responsive_content.dart';
import 'package:dashboard/src/common/widgets/images/custom_image.dart';
import 'package:dashboard/src/core/constants/app_images.dart';
import 'package:dashboard/src/core/theme/app_colors.dart';
import 'package:dashboard/src/core/theme/extensions/text_theme_extension.dart';
import 'package:flutter/material.dart';

enum CustomLoadingType {
  standard, // El modo oscuro translúcido que ya tenías
  white, // Nuevo modo fondo blanco
  custom, // Configuración manual
}

class CustomLoading extends StatelessWidget {
  const CustomLoading({
    super.key,
    this.type = CustomLoadingType.standard, // Por defecto es el estándar
    this.loadingText,
    this.indicatorHeight = 5,
    // Optional properties for the Custom mode
    this.backgroundColor,
    this.indicatorColor,
    this.loadingTextStyle,
    this.backgroundIndicatorColor,
    this.isLoading = false,
  }) : assert(
         type != CustomLoadingType.custom ||
             (backgroundColor != null || indicatorColor != null),
         'Si usas CustomLoadingType.custom, considera definir al menos el '
         'backgroundColor o indicatorColor, o se usarán los defaults.',
       );
  final bool isLoading;
  final CustomLoadingType type;
  final String? loadingText;
  final double indicatorHeight;

  // Propiedades nullable porque se calcularán en el build
  final Color? backgroundColor;
  final Color? indicatorColor;
  final Color? backgroundIndicatorColor;
  final TextStyle? loadingTextStyle;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // --- Definir colores y estilos según el tipo ---
    late final Color finalBgColor;
    late final Color finalIndicatorColor;
    late final Color finalBgIndicatorColor;
    late final TextStyle finalTextStyle;

    switch (type) {
      case CustomLoadingType.standard:
        // El estilo original (Oscuro translúcido) pero usando el tema
        // Si el tema es oscuro, scaffoldBackgroundColor será oscuro.
        finalBgColor = Theme.of(
          context,
        ).scaffoldBackgroundColor.withAlpha((0.6 * 255).toInt());
        finalIndicatorColor = AppColors.primary;
        finalBgIndicatorColor = AppColors.grey;
        finalTextStyle = loadingTextStyle ?? context.bodyLarge;

      case CustomLoadingType.white:
        // Nuevo estilo (Fondo blanco sólido o translúcido)
        finalBgColor = Colors.white.withAlpha((0.6 * 255).toInt());
        finalIndicatorColor = AppColors.primary;
        finalBgIndicatorColor = AppColors.grey.withAlpha((0.3 * 255).toInt());
        // En fondo blanco, forzamos texto oscuro si no se pasa uno custom
        finalTextStyle =
            loadingTextStyle ??
            context.bodyLarge.copyWith(color: AppColors.black);

      case CustomLoadingType.custom:
        // Usa los valores pasados o defaults de seguridad
        finalBgColor =
            backgroundColor ??
            Theme.of(
              context,
            ).scaffoldBackgroundColor.withAlpha((0.6 * 255).toInt());
        finalIndicatorColor = indicatorColor ?? AppColors.primary;
        finalBgIndicatorColor = backgroundIndicatorColor ?? AppColors.grey;
        finalTextStyle = loadingTextStyle ?? context.bodyLarge;
    }

    if (!isLoading) return const SizedBox.shrink();

    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        // Fondo
        Container(decoration: BoxDecoration(color: finalBgColor)),
        SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CustomImage(
                AppImages.imageLogo,
                width: Responsive.isMobile(context) ? size.width * 0.30 : 400,
                childNoImage: const Icon(Icons.image_rounded),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                width: Responsive.isMobile(context) ? size.width * 0.60 : 400,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    minHeight: indicatorHeight,
                    backgroundColor: finalBgIndicatorColor,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      finalIndicatorColor,
                    ),
                  ),
                ),
              ),
              if (loadingText != null && loadingText!.isNotEmpty)
                Text(loadingText!, style: finalTextStyle),
            ],
          ),
        ),
      ],
    );
  }
}
