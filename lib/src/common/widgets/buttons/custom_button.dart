import 'package:dashboard/src/core/theme/app_colors.dart';
import 'package:dashboard/src/core/theme/extensions/text_theme_extension.dart';
import 'package:flutter/material.dart';

/// Define el estilo visual principal del botón.
enum CustomButtonType {
  /// Relleno, el más prominente (equivalente a ElevatedButton).
  filled,

  /// Con borde, para acciones secundarias (equivalente a OutlinedButton).
  outlined,

  /// Solo texto, para acciones de baja prominencia (equivalente a TextButton).
  text,
}

/// Define la paleta de colores o el propósito semántico del botón.
enum CustomButtonVariant {
  /// Verde (Brand) - Para acciones primarias y positivas (CTA).
  primary,

  /// Negro (Dark) - Para acciones secundarias o un look neutral.
  secondary,

  /// Rojo (Error) - Para acciones destructivas o peligrosas.
  destructive,
}

/// Define el tamaño y el padding del botón.
enum CustomButtonSize { extraSmall, small, medium, large }

/// --- El Widget de Botón Unificado ---
///
/// Un único widget de botón que maneja todas las variantes de la app
/// (color, estilo, tamaño, e iconos)
class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.onPressed,
    this.text,
    this.icon,
    this.child,
    this.type = CustomButtonType.filled,
    this.variant = CustomButtonVariant.primary,
    this.size = CustomButtonSize.medium,
    this.isExpanded = false,
    this.onLongPress,
    // custom
    this.customColor,
    this.onCustomColor,
    this.isLoading = false,
  }) : assert(
         text != null || icon != null || child != null,
         'Debes proveer un "text", "icon", o "child".',
       ),
       assert(
         !(type == CustomButtonType.filled &&
             customColor != null &&
             onCustomColor == null),
         'Si provees un "customColor" para un botón "filled", '
         'también debes proveer un "onCustomColor" (para el texto/icono).',
       );

  /// La acción a ejecutar cuando se presiona.
  /// **Si es null, el botón se mostrará deshabilitado.**
  final VoidCallback? onPressed;

  /// La acción a ejecutar con una pulsación larga.
  final VoidCallback? onLongPress;

  /// El texto que se mostrará si no se provee un [child].
  final String? text;

  /// El icono que se mostrará.
  /// Si [text] y [child] son null, se renderizará como un botón de icono
  /// circular.
  final Widget? icon;

  /// El widget hijo customizado. Tiene precedencia sobre [text].
  final Widget? child;

  /// El estilo visual (filled, outlined, text).
  final CustomButtonType type;

  /// La paleta de colores (primary, secondary, destructive).
  final CustomButtonVariant variant;

  /// El tamaño (small, medium, large).
  final CustomButtonSize size;

  /// Si es true, el botón se expandirá para llenar el ancho disponible.
  final bool isExpanded;

  /// Color personalizado que anula la [variant].
  /// - Para `filled`: es el color de fondo.
  /// - Para `outlined`: es el color del texto y el borde.
  /// - Para `text`: es el color del texto.
  final Color? customColor;

  /// Color del texto/icono para un botón `filled` con [customColor].
  /// Se ignora para los tipos `outlined` y `text`.
  final Color? onCustomColor;

  /// Si es true, el botón mostrará un indicador de carga y se deshabilitará.
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    // Determina si es un botón de icono puro (circular)
    final isIconButton = icon != null && text == null && child == null;

    final buttonStyle = _buildButtonStyle(
      context,
      type,
      variant,
      size,
      isIconButton,
    );

    final indicatorColor =
        buttonStyle.foregroundColor?.resolve({}) ?? Colors.white;

    final buttonContent = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
            ),
          )
        : (child ??
              (isIconButton
                  ? icon!
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (icon != null) ...[
                          icon!,
                          SizedBox(width: _getPadding(size) / 2),
                        ],
                        if (text != null)
                          Flexible(
                            child: Text(
                              text!,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                      ],
                    )));

    Widget button;

    switch (type) {
      case CustomButtonType.filled:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          onLongPress: onLongPress,
          style: buttonStyle,
          child: buttonContent,
        );
      case CustomButtonType.outlined:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          onLongPress: onLongPress,
          style: buttonStyle,
          child: buttonContent,
        );
      case CustomButtonType.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          onLongPress: onLongPress,
          style: buttonStyle,
          child: buttonContent,
        );
    }

    if (isExpanded) {
      return Row(children: [Expanded(child: button)]);
    }

    return button;
  }

  /// El "cerebro" que construye el ButtonStyle basado en las variantes.
  ButtonStyle _buildButtonStyle(
    BuildContext context,
    CustomButtonType type,
    CustomButtonVariant variant,
    CustomButtonSize size,
    bool isIconButton,
  ) {
    // --- Colores base (los de tu paleta) ---
    const colorPrimary = AppColors.primary;
    const colorSecondary = AppColors.black;
    const colorDestructive = AppColors.red;
    const colorOnPrimary = AppColors.black; // Texto negro sobre verde
    const colorOnSecondary = AppColors.primary; // Texto verde sobre negro
    const colorOnDestructive = AppColors.white; // Texto blanco sobre rojo

    // --- COLORES CLAVE PARA DESHABILITADO ---
    const colorDisabledBackground = AppColors.lightGrey;
    const colorDisabledForeground = AppColors.grey;
    const colorDisabledBorder = AppColors.grey;

    // Estilo de texto alineado a CustomButtonV2
    final textStyle = context.buttonText.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w600,
    );

    // Padding basado en el tamaño
    final padding = _getPadding(size);

    // --- Definición de Colores (para estado HABILITADO) ---
    Color? backgroundColor;
    Color? foregroundColor;
    BorderSide? side;
    final isCustom = customColor != null;

    if (isCustom) {
      // --- 1. LÓGICA DE COLOR PERSONALIZADO ---
      switch (type) {
        case CustomButtonType.filled:
          backgroundColor = customColor;
          foregroundColor = onCustomColor; // <-- Usamos el color "on"

        case CustomButtonType.outlined:
          backgroundColor = Colors.transparent;
          foregroundColor = customColor; // <-- Color para texto y borde
          side = BorderSide(color: customColor!, width: 1.5);

        case CustomButtonType.text:
          backgroundColor = Colors.transparent;
          foregroundColor = customColor; // <-- Color para texto
      }
    } else {
      switch (type) {
        case CustomButtonType.filled:
          switch (variant) {
            case CustomButtonVariant.primary:
              backgroundColor = colorPrimary;
              foregroundColor = colorOnPrimary;
            case CustomButtonVariant.secondary:
              backgroundColor = colorSecondary;
              foregroundColor = colorOnSecondary;
            case CustomButtonVariant.destructive:
              backgroundColor = colorDestructive;
              foregroundColor = colorOnDestructive;
          }
        case CustomButtonType.outlined:
          // El fondo es transparente
          switch (variant) {
            case CustomButtonVariant.primary:
              foregroundColor = colorPrimary;
              side = const BorderSide(color: colorPrimary, width: 1.5);
            case CustomButtonVariant.secondary:
              foregroundColor = colorSecondary;
              side = const BorderSide(width: 1.5);
            case CustomButtonVariant.destructive:
              foregroundColor = colorDestructive;
              side = const BorderSide(color: colorDestructive, width: 1.5);
          }
        case CustomButtonType.text:
          // Sin fondo, sin borde
          switch (variant) {
            case CustomButtonVariant.primary:
              foregroundColor = colorPrimary;
            case CustomButtonVariant.secondary:
              foregroundColor = colorSecondary;
            case CustomButtonVariant.destructive:
              foregroundColor = colorDestructive;
          }
      }
    }

    // --- Definición de Estilo (común a todos) ---
    return ButtonStyle(
      textStyle: WidgetStateProperty.all(textStyle),
      elevation: WidgetStateProperty.all(0),
      minimumSize: WidgetStateProperty.all(Size.zero),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      // Sin sombra

      // Usamos resolveWith para manejar el estado 'disabled'
      backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.disabled)) {
          if (type == CustomButtonType.filled) {
            return colorDisabledBackground;
          }
          return null; // Sin fondo para outlined/text
        }
        return backgroundColor; // Color normal (habilitado)
      }),
      foregroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.disabled)) {
          return colorDisabledForeground;
        }
        return foregroundColor; // Color normal (habilitado)
      }),
      side: WidgetStateProperty.resolveWith<BorderSide?>((states) {
        if (states.contains(WidgetState.disabled)) {
          if (type == CustomButtonType.outlined) {
            return const BorderSide(color: colorDisabledBorder, width: 1.5);
          }
          return null; // Sin borde para filled/text
        }
        return side; // Borde normal (habilitado)
      }),

      padding: WidgetStateProperty.all(
        isIconButton
            ? EdgeInsets.all(padding)
            : EdgeInsets.symmetric(
                // horizontal: padding == 10 ? 16 : padding * 1.5,
                horizontal: padding * 1.5,
                vertical: padding,
              ),
      ),
      shape: WidgetStateProperty.all(
        isIconButton
            ? const CircleBorder()
            : RoundedRectangleBorder(
                // Forma redondeada igual a CustomButtonV2
                borderRadius: BorderRadius.circular(10),
              ),
      ),
      // Overlay (color de hover/splash)
      overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
        // No aplicar overlay si está deshabilitado
        if (states.contains(WidgetState.disabled)) return null;

        if (states.contains(WidgetState.pressed)) {
          return foregroundColor?.withAlpha((0.12 * 255).toInt());
        }
        if (states.contains(WidgetState.hovered)) {
          return foregroundColor?.withAlpha((0.08 * 255).toInt());
        }
        return null;
      }),
    );
  }

  /// Helper para obtener el padding base
  double _getPadding(CustomButtonSize size) {
    switch (size) {
      case CustomButtonSize.extraSmall:
        return 4;
      case CustomButtonSize.small:
        return 14;
      case CustomButtonSize.medium:
        return 18;
      case CustomButtonSize.large:
        return 22;
    }
  }
}
