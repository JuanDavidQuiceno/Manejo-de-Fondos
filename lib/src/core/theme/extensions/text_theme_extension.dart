import 'package:dashboard/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

// Definimos una fuente base más genérica para los estilos por defecto
// En realidad, cada TextStyle en TextTheme ya tiene un `fontFamily` y `color`
// El `_baseFont` solo sería usado si un estilo específico del TextTheme fuera
// null, lo cual es poco común si tu TextTheme está bien definido. Para el
// propósito de las extensiones, el ?? _baseFont es una buena práctica de
// fallback.
// const _baseFont = TextStyle(
//   fontFamily: 'Delight',
//   fontSize: 14,
//   color: AppColors.black,
//   fontWeight: FontWeight.w400, // Regular
//   height: 1.42, // 20px / 14px
// );

/// Helper function to get the current text theme from the context.
/// This is used to avoid repetitive calls to Theme.of(context).textTheme.
/// It provides a single point of access to the text theme,
/// ensuring consistency and reducing boilerplate code.
/// @param context The BuildContext from which to retrieve the text theme.
/// @return The current TextTheme from the context.
/// This function is used throughout the app to access text styles
/// defined in the theme, allowing for easy customization and theming.
/// It ensures that all text styles are derived from the same base font,
/// maintaining a consistent look and feel across the application.
/// @example
/// ```dart
/// Text('Hello World', style: context.displayLarge);
/// ```
/// This example shows how to use the `displayLarge` style
/// from the text theme extension in a widget.
/// @see [ThemeExtension]
/// @see [TextTheme]
/// @see [AppColors]
///
TextTheme _getTextTheme(BuildContext context) {
  return Theme.of(context).textTheme;
}

/// Extension on BuildContext to provide easy access to custom text styles.
///
/// This extension maps semantic names (e.g., `displayTitle`, `sectionTitle`)
/// to specific `TextStyle` definitions from the application's `TextTheme`.
/// It ensures that all text styles are consistent with the defined theme
/// and simplifies their usage throughout the widget tree.
///
///
// Fuente base actualizada a "Delight" y un estilo por defecto (Body 2).

/// Extensión en BuildContext para proveer acceso fácil a los estilos de texto.
///
/// Mapea nombres semánticos (ej. `displayTitle`, `sectionTitle`)
/// a las definiciones específicas de `TextStyle` del `TextTheme` de la app.
extension AppTextStyles on BuildContext {
  TextStyle _style(TextStyle? style) {
    // Si el estilo no existe, usamos el cuerpo por defecto del tema actual
    return style ?? Theme.of(this).textTheme.bodyMedium!;
  }
  // --- Títulos y Encabezados ---

  /// Mapeado a: displayLarge
  /// Fuente: Delight Bold - 36px
  TextStyle get displayLarge => _style(_getTextTheme(this).displayLarge);

  /// Mapeado a: displayMedium
  /// Fuente: Delight Bold - 36px
  TextStyle get displayTitle {
    return _style(_getTextTheme(this).displayMedium);
  }

  /// Mapeado a: displaySmall
  /// Fuente: Delight Bold - 36px
  TextStyle get displaySmall {
    return _style(_getTextTheme(this).displaySmall);
  }

  /// Mapeado a: headlineLarge
  /// Fuente: H1 - Delight Bold - 32px
  TextStyle get headingLarge {
    return _style(_getTextTheme(this).headlineLarge);
  }

  /// Mapeado a: headingMedium
  /// Fuente: H2 - Delight SemiBold - 28px
  TextStyle get headingMedium {
    return _style(_getTextTheme(this).headlineMedium);
  }

  /// Mapeado a: headlineSmall
  /// Fuente: H3 - Delight SemiBold - 24px
  TextStyle get headlineSmall {
    return _style(_getTextTheme(this).headlineSmall);
  }

  /// Mapeado a: titleLarge
  /// Fuente: H4 - Delight SemiBold - 20px
  TextStyle get titleLarge {
    return _style(_getTextTheme(this).titleLarge);
  }

  /// Mapeado a: titleMedium
  /// Fuente: Body 1 - Delight SemiBold - 16px
  TextStyle get titleMedium {
    return _style(_getTextTheme(this).titleMedium);
  }

  /// Mapeado a: titleSmall
  /// Fuente: Body 2 - Delight SemiBold - 14px
  TextStyle get titleSmall {
    return _style(_getTextTheme(this).titleSmall);
  }

  // --- Cuerpo de Texto ---

  /// Mapeado a: bodyLarge
  /// Fuente: Body 1 - Delight Regular - 16px
  TextStyle get bodyLarge {
    return _style(_getTextTheme(this).bodyLarge);
  }

  /// Mapeado a: bodyMedium
  /// Fuente: Body 2 - Delight Regular - 14px
  TextStyle get bodyMedium {
    return _style(_getTextTheme(this).bodyMedium);
  }

  /// Mapeado a: bodySmall
  /// Fuente: Caption/Label - Delight SemiBold - 12px
  TextStyle get bodySmall {
    return _style(_getTextTheme(this).bodySmall);
  }

  // --- Elementos de Interfaz (Labels, Botones, Links) ---

  /// Mapeado a: labelLarge
  /// Fuente: Body 1 - Delight Bold - 16px
  TextStyle get buttonText {
    return _style(_getTextTheme(this).labelLarge);
  }

  /// Mapeado a: labelMedium
  /// Fuente: Caption/Label - Delight SemiBold - 12px
  TextStyle get inputLabel {
    return _style(_getTextTheme(this).labelMedium);
  }

  /// Mapeado a: labelSmall
  /// Fuente: Caption/Label - Delight Regular - 12px
  TextStyle get tinyLink {
    return _style(_getTextTheme(this).labelSmall);
  }
}

/// Extension on TextStyle to provide underlined text with proper spacing
///
/// Adds underline decoration with increased spacing between text and line
extension TextStyleUnderlineExtension on TextStyle {
  /// Retorna un TextStyle con subrayado y espaciado adecuado entre texto y
  /// línea
  ///
  /// Usa el estilo base proporcionado y agrega:
  /// - TextDecoration.underline
  /// - decorationThickness ajustado
  /// - height aumentado para crear espacio entre texto y línea
  ///
  /// Ejemplo:
  /// ```dart
  /// Text(
  ///   'Forgot password?',
  ///   style: context.titleMedium.withUnderline(),
  /// )
  /// ```
  TextStyle withUnderline({
    Color? decorationColor,
    double? decorationThickness,
  }) {
    return copyWith(
      decoration: TextDecoration.underline,
      decorationColor: decorationColor ?? color ?? AppColors.black,
      decorationThickness: decorationThickness ?? 1.2, // Grosor de la línea
      height: (height ?? 1.0) * 1.3, // Aumentar height para crear espacio
    );
  }
}
