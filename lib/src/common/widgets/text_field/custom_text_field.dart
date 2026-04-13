// Asegúrate de que estas rutas de importación sean correctas

import 'package:dashboard/src/core/theme/app_colors.dart';
import 'package:dashboard/src/core/theme/extensions/text_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// ---  TEMA BASE DE DECORACIÓN DE INPUT ---
///
/// Esta es la "base" que pediste. Define la apariencia de todos los inputs.
/// Debes aplicar esto en el `inputDecorationTheme` de tu `ThemeData`
/// en `main.dart`.
class AppInputTheme {
  static InputDecorationTheme get lightTheme {
    const borderRadius = 100.0; // Píldora
    const enabledBorderColor = AppColors.gray200;
    const focusedBorderColor = AppColors.primary;
    const errorBorderColor = AppColors.red;
    const hintColor = AppColors.gray400;
    const fillColor = AppColors.white; // Fondo blanco

    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      // Quita el label flotante, ya que lo manejamos manualmente
      floatingLabelBehavior: FloatingLabelBehavior.never,

      // Estilo del Hint (placeholder)
      hintStyle: const TextStyle(color: hintColor, fontSize: 16),
      // Estilo del error (texto rojo debajo)
      errorStyle: const TextStyle(color: errorBorderColor, fontSize: 12),
      // Padding interno del campo
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),

      // --- Bordes ---
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(color: enabledBorderColor, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(color: enabledBorderColor, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(color: focusedBorderColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(color: errorBorderColor, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(color: errorBorderColor, width: 2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(
          color: enabledBorderColor.withAlpha((0.5 * 255).toInt()),
          width: 1.5,
        ),
      ),
    );
  }
}

/// --- 2. TU CUSTOM TEXT FIELD (MODIFICADO) ---
///
/// Este widget ahora renderiza el [labelText] como un widget `Text`
/// separado, encima del campo de texto, tal como en tu diseño.
class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    // Control properties
    this.focusNode,
    this.controller,
    this.initialValue,
    this.readOnly = false,
    this.enabled = true,
    this.obscureText = false,

    // Behavior properties
    this.textInputAction = TextInputAction.next,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.inputFormatters,

    // El labelText ahora se muestra arriba.
    this.labelText,
    this.cursorColor,
    this.labelStyle,
    this.hintText,
    this.textAlign = TextAlign.start,
    this.contentPadding,

    this.helperText,
    this.errorText,
    this.style,
    this.decoration,
    this.radius,
    this.suffix,
    this.suffixIcon,
    this.suffixIconConstraints,
    this.prefix,
    this.prefixIcon,
    this.prefixIconConstraints,

    // Content properties
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.errorMaxLines = 5,

    // Callbacks
    this.onTap,
    this.onChanged,
    this.onSaved,
    this.onTapOutSide,
    this.onFieldSubmitted,

    // Validation
    this.validator,
  });

  // ... (todas tus propiedades finales van aquí sin cambios) ...
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final String? initialValue;
  final bool readOnly;
  final bool enabled;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final bool autocorrect;
  final bool enableSuggestions;
  final AutovalidateMode? autovalidateMode;
  final List<TextInputFormatter>? inputFormatters;
  final String? labelText;
  final TextStyle? labelStyle;
  final TextAlign textAlign;
  final EdgeInsetsGeometry? contentPadding;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final TextStyle? style;
  final Color? cursorColor;
  final InputDecoration? decoration;
  final double? radius;
  final Widget? suffix;
  final Widget? suffixIcon;
  final BoxConstraints? suffixIconConstraints;
  final Widget? prefix;
  final Widget? prefixIcon;
  final BoxConstraints? prefixIconConstraints;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final int? errorMaxLines;
  final void Function()? onTap;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final void Function(PointerDownEvent)? onTapOutSide;
  final void Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // El estilo por defecto para el Label (puedes ajustarlo)
    final defaultLabelStyle = context.bodyLarge;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- 1. EL LABEL (EXTERNO) ---
        if (labelText != null) ...[
          Text(labelText!, style: labelStyle ?? defaultLabelStyle),
          const SizedBox(height: 4),
        ],

        // --- 2. EL CAMPO DE TEXTO ---
        TextFormField(
          focusNode: focusNode,
          controller: controller,
          textInputAction: textInputAction,
          keyboardType: keyboardType,
          textAlign: textAlign,
          textCapitalization: textCapitalization,
          obscureText: obscureText,
          autocorrect: autocorrect,
          enableSuggestions: enableSuggestions,
          maxLength: maxLength,
          maxLines: obscureText ? 1 : maxLines,
          minLines: minLines,
          initialValue: initialValue,
          inputFormatters: inputFormatters,
          readOnly: readOnly,
          cursorColor: cursorColor,
          style:
              style ??
              context.bodyLarge.copyWith(color: theme.colorScheme.onSurface),
          decoration:
              // Usamos 'decoration' si lo provees, si no, creamos uno
              decoration ??
              InputDecoration(
                hintText: hintText,
                helperText: helperText,
                errorText: errorText,
                suffix: suffix,
                suffixIcon: suffixIcon,
                suffixIconConstraints: suffixIconConstraints,
                prefix: prefix,
                prefixIcon: prefixIcon,
                prefixIconConstraints: prefixIconConstraints,
                errorMaxLines: errorMaxLines,
                contentPadding: contentPadding,
                counterText: '', // Hide default counter when maxLength is set
                // Se aplica el tema que definimos en AppInputTheme
              ).applyDefaults(theme.inputDecorationTheme),
          autovalidateMode: autovalidateMode,
          onTap: onTap,
          onChanged: onChanged,
          onSaved: onSaved,
          onTapOutside: onTapOutSide,
          onFieldSubmitted: onFieldSubmitted,
          validator: validator,
          enabled: enabled,
        ),
      ],
    );
  }
}

/// --- 3. WIDGET DE CONTRASEÑA ---
///
/// Un widget que usa [CustomTextField] internamente para manejar la
/// lógica de mostrar/ocultar contraseña.
class CustomPasswordField extends StatefulWidget {
  const CustomPasswordField({
    super.key,
    this.initialValue,
    this.controller,
    this.focusNode,
    this.labelText,
    this.hintText = '*********',
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTapOutSide,
    this.textInputAction = TextInputAction.done,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.maxLength,
  });

  final String? initialValue;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? labelText;
  final String? hintText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final void Function(PointerDownEvent)? onTapOutSide;
  final TextInputAction? textInputAction;
  final AutovalidateMode? autovalidateMode;
  final int? maxLength;

  @override
  State<CustomPasswordField> createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      initialValue: widget.initialValue,
      autovalidateMode: widget.autovalidateMode,
      controller: widget.controller,
      focusNode: widget.focusNode,
      labelText: widget.labelText,
      hintText: widget.hintText,
      obscureText: _obscureText,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
      onTapOutSide: widget.onTapOutSide,
      textInputAction: widget.textInputAction,
      maxLength: widget.maxLength,
      suffixIcon: Padding(
        padding: const EdgeInsets.only(right: 5),
        child: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: _toggleVisibility,
        ),
      ),
    );
  }
}
