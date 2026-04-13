import 'package:dashboard/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppThemes {
  static final ThemeData light = _buildLightTheme();
  static final ThemeData dark = _buildDarkTheme();

  /// Construye el TEMA CLARO de la aplicación
  static ThemeData _buildLightTheme() {
    const colors = AppColorsExtension.light;
    return ThemeData(
      fontFamily: 'Delight',
      brightness: Brightness.light,
      extensions: const <ThemeExtension<dynamic>>[AppColorsExtension.light],
      colorScheme: _colorScheme(Brightness.light),
      scaffoldBackgroundColor: colors.background,
      textTheme: _buildTextTheme(AppColors.black),
      appBarTheme: _appBarTheme(colors),
      buttonTheme: _buttonTheme(),
      inputDecorationTheme: _inputDecorationTheme(Brightness.light),
      dividerTheme: _dividerTheme(),
      tooltipTheme: _tooltipTheme(Brightness.light),
      cardTheme: _cardTheme(colors),
      switchTheme: _switchTheme(Brightness.light),
    );
  }

  /// Construye el TEMA OSCURO de la aplicación (migrado desde tu archivo
  /// original)
  static ThemeData _buildDarkTheme() {
    const colors = AppColorsExtension.dark;
    return ThemeData(
      fontFamily: 'Delight',
      brightness: Brightness.dark,
      extensions: const <ThemeExtension<dynamic>>[AppColorsExtension.dark],
      colorScheme: _colorScheme(Brightness.dark),
      scaffoldBackgroundColor: colors.background,
      textTheme: _buildTextTheme(const Color(0xFFFFFFFF)),
      appBarTheme: _appBarTheme(colors),
      buttonTheme: _buttonTheme(),
      inputDecorationTheme: _inputDecorationTheme(Brightness.dark),
      dividerTheme: _dividerTheme(),
      tooltipTheme: _tooltipTheme(Brightness.dark),
      cardTheme: _cardTheme(colors),
      switchTheme: _switchTheme(Brightness.dark),
    );
  }

  // --- MÉTODOS AUXILIARES ---
  static ColorScheme _colorScheme(Brightness brightness) {
    return ColorScheme(
      brightness: brightness,
      primary: AppColors.primary,
      onPrimary: AppColors.white,
      secondary: AppColors.grey,
      onSecondary: AppColors.black,
      error: AppColors.error,
      onError: AppColors.white,
      surface: (brightness == Brightness.dark)
          ? AppColorsExtension.dark.background
          : AppColorsExtension.light.background,
      onSurface: (brightness == Brightness.dark)
          ? AppColorsExtension.dark.onSurface
          : AppColorsExtension.light.onSurface,
      // Colores adicionales de tu tema
      tertiary: AppColors.success,
      outline: AppColorsExtension.dark.background,
    );
  }

  static TextTheme _buildTextTheme(Color color) {
    const font = 'Delight';

    // --- Mapeo de Pesos de Fuente ---
    // Asumimos mapeos estándar para la fuente "Delight"
    const fwRegular = FontWeight.w400;
    const fwSemiBold = FontWeight.w600;
    const fwBold = FontWeight.w700;

    return TextTheme(
      // ✅ Mapeado a: Delight Bold - 36px
      // Altura de línea: 40px (40 / 36 = 1.11)
      displayLarge: TextStyle(
        fontFamily: font,
        fontWeight: fwBold,
        fontSize: 36,
        color: color,
        height: 1.11,
      ),
      // ✅ Mapeado a: Delight Bold - 36px
      // Altura de línea: 40px (40 / 36 = 1.11)
      displayMedium: TextStyle(
        fontFamily: font,
        fontWeight: fwBold,
        fontSize: 36,
        color: color,
        height: 1.11,
      ),
      // ✅ Mapeado a: Delight Bold - 36px
      // Altura de línea: 40px (40 / 36 = 1.11)
      displaySmall: TextStyle(
        fontFamily: font,
        fontWeight: fwBold,
        fontSize: 36,
        color: color,
        height: 1.11,
      ),

      // ✅ Mapeado a: H1 - Delight Bold - 32px
      // Altura de línea: 36px (36 / 32 = 1.125)
      headlineLarge: TextStyle(
        fontFamily: font,
        fontWeight: fwBold,
        fontSize: 32,
        color: color,
        height: 1.125,
      ),
      // ✅ Mapeado a: H2 - Delight SemiBold - 28px
      // Altura de línea: 32px (32 / 28 = 1.14)
      headlineMedium: TextStyle(
        fontFamily: font,
        fontWeight: fwSemiBold,
        fontSize: 28,
        color: color,
        height: 1.14,
      ),

      // ✅ Mapeado a: H3 - Delight SemiBold - 24px
      // Altura de línea: 28px (28 / 24 = 1.16)
      headlineSmall: TextStyle(
        fontFamily: font,
        fontWeight: fwSemiBold,
        fontSize: 24,
        color: color,
        height: 1.16,
      ),

      // ✅ Mapeado a: H4 - Delight SemiBold - 20px
      // Altura de línea: 26px (26 / 20 = 1.3)
      titleLarge: TextStyle(
        fontFamily: font,
        fontWeight: fwSemiBold,
        fontSize: 20,
        color: color,
        height: 1.3,
      ),
      // ✅ Mapeado a: Body 1 - Delight SemiBold - 16px
      // Altura de línea: 24px (24 / 16 = 1.5)
      titleMedium: TextStyle(
        fontFamily: font,
        fontWeight: fwSemiBold,
        fontSize: 16,
        color: color,
        height: 1.5,
      ),
      // ✅ Mapeado a: Body 2 - Delight SemiBold - 14px
      // Altura de línea: 20px (20 / 14 = 1.42)
      titleSmall: TextStyle(
        fontFamily: font,
        fontWeight: fwSemiBold,
        fontSize: 14,
        color: color,
        height: 1.42,
      ),

      // ✅ Mapeado a: Body 1 - Delight Regular - 16px
      // Altura de línea: 24px (24 / 16 = 1.5)
      bodyLarge: TextStyle(
        fontFamily: font,
        fontWeight: fwRegular,
        fontSize: 16,
        color: color,
        height: 1.5,
      ),

      // ✅ Mapeado a: Body 2 - Delight Regular - 14px
      // Altura de línea: 20px (20 / 14 = 1.42)
      bodyMedium: TextStyle(
        fontFamily: font,
        fontWeight: fwRegular,
        fontSize: 14,
        color: color,
        height: 1.42,
      ),
      // ✅ Mapeado a: Caption/Label - Delight SemiBold - 12px
      // Altura de línea: 16px (16 / 12 = 1.33)
      bodySmall: TextStyle(
        fontFamily: font,
        fontWeight: fwSemiBold,
        fontSize: 12,
        color: color,
        height: 1.33,
      ),

      // ✅ Mapeado a: Body 1 - Delight Bold - 16px
      // Altura de línea: 24px (24 / 16 = 1.5)
      labelLarge: TextStyle(
        fontFamily: font,
        fontWeight: fwBold,
        fontSize: 16,
        color: color,
        height: 1.5,
      ),

      // ✅ Mapeado a: Caption/Label - Delight SemiBold - 12px
      // Altura de línea: 16px (16 / 12 = 1.33)
      labelMedium: TextStyle(
        fontFamily: font,
        fontWeight: fwSemiBold,
        fontSize: 12,
        color: color,
        height: 1.33,
      ),

      // ✅ Mapeado a: Caption/Label - Delight Regular - 12px
      // Altura de línea: 16px (16 / 12 = 1.33)
      labelSmall: TextStyle(
        fontFamily: font,
        fontWeight: fwRegular,
        fontSize: 12,
        color: color,
        height: 1.33,
      ),
    );
  }

  static AppBarTheme _appBarTheme(AppColorsExtension colors) {
    return AppBarTheme(
      // backgroundColor: colors.backgroundColor,
      iconTheme: IconThemeData(color: colors.backgroundIconColor, size: 24),
      elevation: 1,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      actionsIconTheme: IconThemeData(
        color: colors.backgroundIconColor,
        size: 24,
      ),

      // color: AppColors.primaryColor,
    );
  }

  static CardThemeData _cardTheme(AppColorsExtension colors) {
    return CardThemeData(
      color: colors.card,
      // shadowColor: Colors.black.withAlpha((0.2 * 255).toInt()),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(8),
    );
  }

  static ButtonThemeData _buttonTheme() {
    return ButtonThemeData(
      buttonColor: AppColors.primary,
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
    );
  }

  static SwitchThemeData _switchTheme(Brightness brightness) {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.grey;
        }
        // Force the thumb to ALWAYS be white, overriding the default behavior
        // where it turns primary color on hover or when unselected.
        return AppColors.white;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.grey.withAlpha(50);
        }
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return AppColors.grey.withAlpha(100);
      }),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.focused) ||
            states.contains(WidgetState.pressed)) {
          // Soft splash color instead of full primary
          return AppColors.primary.withAlpha(25);
        }
        return Colors.transparent;
      }),
      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
    );
  }

  static InputDecorationTheme _inputDecorationTheme(Brightness brightness) {
    const font = 'Delight';
    const double borderRadius = 40; // Forma de píldora

    // Colores dependientes del tema
    final enabledBorderColor = brightness == Brightness.dark
        ? AppColorsExtension.dark.onSurface
        : AppColors.black;
    const focusedBorderColor = AppColors.primary; // Color primario
    const errorBorderColor = AppColors.red;
    const hintColor = AppColors.grey;
    final fillColor = brightness == Brightness.dark
        ? AppColorsExtension.dark.card
        : AppColors.white; // Fondo blanco

    // --- Retornamos el nuevo tema ---
    return InputDecorationTheme(
      // --- Bordes ---
      // Esto reemplaza tu 'InputBorder.none'
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: enabledBorderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(color: focusedBorderColor, width: 1.2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(color: errorBorderColor, width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(color: errorBorderColor, width: 1.2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(
          color: enabledBorderColor.withAlpha((0.5 * 255).toInt()),
        ),
      ),

      // --- Color de fondo ---
      // Esto reemplaza tu 'AppColors.transparent'
      filled: true,
      fillColor: fillColor,
      // --- Padding ---
      // Ajustado para que se vea bien con la forma de píldora
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),

      // --- Comportamiento del Label ---
      // ¡MUY IMPORTANTE!
      // Esto le dice a Flutter que no maneje el label,
      // ya que tu CustomTextField lo muestra *afuera*.
      floatingLabelBehavior: FloatingLabelBehavior.never,

      // --- Estilos de Texto ---
      hintStyle: const TextStyle(
        fontFamily: font,
        fontWeight: FontWeight.w400,
        fontSize: 16,
        color: hintColor, // Color de placeholder
      ),
      errorStyle: const TextStyle(
        fontFamily: font,
        fontWeight: FontWeight.w400,
        fontSize: 12,
        color: errorBorderColor, // Color de error
      ),
      labelStyle: const TextStyle(
        fontFamily: font,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      helperStyle: const TextStyle(
        fontFamily: font,
        fontWeight: FontWeight.w400,
        fontSize: 12, // Más pequeño para texto de ayuda
        color: hintColor,
      ),
    );
  }

  static DividerThemeData _dividerTheme() {
    return const DividerThemeData(color: AppColors.grey, thickness: 1);
  }

  static TooltipThemeData _tooltipTheme(Brightness brightness) {
    const font = 'Delight';
    final isDark = brightness == Brightness.dark;

    return TooltipThemeData(
      preferBelow: false,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      textStyle: TextStyle(
        fontFamily: font,
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: isDark ? AppColors.white : const Color(0XFF1B1B1A),
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2E2E2E) : const Color(0xFFFBFBFB),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(10, 13, 18, 0.08),
            offset: Offset(0, 12),
            blurRadius: 16,
            spreadRadius: -4,
          ),
          BoxShadow(
            color: Color.fromRGBO(10, 13, 18, 0.03),
            offset: Offset(0, 4),
            blurRadius: 6,
            spreadRadius: -2,
          ),
        ],
      ),
    );
  }
}
