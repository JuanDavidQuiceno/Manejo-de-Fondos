import 'package:flutter/material.dart';

@immutable
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  const AppColorsExtension({
    required this.background,
    required this.hintColor,
    required this.backgroundIconColor,
    required this.alertColor,
    required this.transparent,
    required this.onSurface,
    required this.card,
  });

  final Color background;
  final Color hintColor;
  final Color backgroundIconColor;
  final Color alertColor;
  final Color transparent;
  final Color onSurface;
  final Color card;

  static const AppColorsExtension light = AppColorsExtension(
    background: Color(0xFFFFFFFF),
    hintColor: Color(0xFF9E9E9E), // Más claro, mejor contraste
    backgroundIconColor: Color(0xFF212121), // Oscuro para buena visibilidad
    alertColor: Color(0xFFFFF9C4), // Amarillo claro para alertas
    transparent: Colors.transparent,
    onSurface: Color(0xFF000000),
    card: Color(0xFFFFFFFF), // Gris claro, más neutro
  );

  // Dark mode estandarizado (Tono "Slate Blue") con más contraste
  static const AppColorsExtension dark = AppColorsExtension(
    background: Color(0xFF020617), // Slate 950 (Fondo más oscuro)
    hintColor: Color(0xFF94A3B8), // Slate 400
    backgroundIconColor: Color(0xFFF1F5F9), // Slate 100
    alertColor: Color(0xFF1E293B), // Slate 800
    transparent: Colors.transparent,
    onSurface: Color(0xFFF1F5F9), // Slate 100
    card: Color(0xFF1E293B), // Slate 800 (Superficie / Card más clara)
  );

  @override
  ThemeExtension<AppColorsExtension> copyWith() => this;

  @override
  ThemeExtension<AppColorsExtension> lerp(
    ThemeExtension<AppColorsExtension>? other,
    double t,
  ) => this;
}

class AppColors {
  AppColors._();

  static const primary = Color(0xFF2697FF); // Azul brillante
  static const red = Color(0xFFD70926); // Rojo intenso
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
  static const grey = Color(0xFFC4C4C4);
  // NUEVO: útil para bordes/dividers
  static const lightGrey = Color(0xFFE0E0E0);

  static const darkGrey = Color(0xFF757575); // NUEVO: útil para texto oscuro
  static const green = Color(0xFF4CAF50); // NUEVO: verde éxito accesible
  static const orange = Color(0xFFFFA500);
  static const transparent = Colors.transparent;
  static const purple = Color(0xFF9C27B0); // NUEVO: púrpura para destacar
  static const blue = Color(0xFF2196F3); // NUEVO: azul para enlaces y botones
  static const yellow = Color(0xFFFFEB3B); // NUEVO: amarillo para advertencias
  static const pink = Color(0xFFE91E63); // NUEVO: rosa para acentos

  // Consolidado: usar los colores nombrados según intención
  static const success = green;
  static const warning = Color(0xFFFFC107); // Amarillo estándar Material
  static const error = red;
  static const pending = Color(0xFFFF9800);
  static const inactived = grey;

  // --- Escala de Grises (Neutral Palette) ---
  static const gray50 = Color(0xFFFAFAFA);
  static const gray100 = Color(0xFFF5F5F5);
  static const gray200 = Color(0xFFEEEEEE); // Ideal para fondos
  static const gray300 = Color(0xFFE0E0E0); // Ideal para bordes/dividers
  static const gray400 = Color(0xFFBDBDBD); // Iconos inactivos
  static const gray500 = Color(0xFF9E9E9E); // Texto secundario
  static const gray600 = Color(0xFF757575);
  static const gray700 = Color(0xFF616161);
  static const gray800 = Color(0xFF424242); // Texto principal
  static const gray900 = Color(0xFF212121);

  // --- Colores Semánticos (Feedback) ---
  static const info = blue; // Azul informativo

  // --- Colores de Contenido (Texto e Iconos) ---
  static const textPrimary = Color(0xFF212121); // Títulos, contenido principal
  static const textSecondary = Color(0xFF757575); // Subtítulos, descripciones
  static const textDisabled = Color(0xFFBDBDBD); // Texto deshabilitado

  // --- Elementos de UI Específicos ---
  static const divider = Color(0xFFE0E0E0); // Líneas divisorias
  static const focus = Color(0xFF2697FF); // Bordes de inputs activos
  static const shimmerBase = Color(0xFFE0E0E0); // Para efectos de carga
  static const shimmerHighlight = Color(0xFFF5F5F5);

  // --- Variantes de Acción ---
  static const primaryHover = Color(0xFF1E88E5);
  static const primaryPressed = Color(0xFF1565C0);
}
