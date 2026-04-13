import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

mixin FormValidationMixin {
  /// Input formatter que permite solo letras (incluyendo acentos) y espacios.
  ///
  /// Útil para campos de nombre donde no se permiten números ni caracteres
  /// especiales.
  ///
  /// Ejemplo de uso:
  /// ```dart
  /// CustomTextField(
  ///   inputFormatters: [lettersAndSpacesFormatter],
  /// )
  /// ```
  TextInputFormatter get lettersAndSpacesFormatter =>
      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ\s]'));

  /// Valida que un campo no esté vacío.
  String? validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio.';
    }
    return null; // El valor es válido
  }

  /// Valida un nombre (first name o last name).
  /// Requiere mínimo 3 letras y máximo 25 caracteres.
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio.';
    }

    // Contar solo letras (sin espacios ni caracteres especiales)
    final lettersOnly = value.replaceAll(RegExp('[^a-zA-ZáéíóúÁÉÍÓÚñÑ]'), '');

    if (lettersOnly.length < 3) {
      return 'El nombre debe tener al menos 3 letras.';
    }

    if (value.length > 25) {
      return 'El nombre no puede superar los 25 caracteres.';
    }

    return null; // El valor es válido
  }

  /// Valida un formato de email simple.
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'El correo electrónico es obligatorio.';
    }

    if (value.length > 100) {
      return 'El correo no puede superar los 100 caracteres.';
    }

    // Expresión regular simple para validar email
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Ingresa un correo electrónico válido.';
    }
    return null; // El valor es válido
  }

  String? validatePhone(String? value, {String? selectCountrycode}) {
    if (value == null || value.isEmpty) {
      return 'El número de teléfono es obligatorio.';
    }

    // Remove any non-digit characters
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');

    if (digitsOnly.length != 10) {
      return 'Ingresa un número de teléfono válido de 10 dígitos.';
    }
    return null;
  }

  // validacion para identificar en una sola validacion si es email o telefono
  String? validateEmailOrPhone(
    String? value, {
    int maxLengthPhone = 10,
    int minLengthPhone = 7,
  }) {
    if (value == null || value.isEmpty) {
      return 'El correo electrónico es obligatorio.';
    }
    final phoneRegex = RegExp(r'^[0-9]+$');
    // si coincide con el phone regex asumimos que quiere validar un telefono
    if (phoneRegex.hasMatch(value)) {
      // validamos la longitud minima
      if (value.length < minLengthPhone) {
        return 'Ingresa un número de teléfono válido con al menos '
            '$minLengthPhone dígitos.';
      }
      if (value.length > maxLengthPhone) {
        return 'El teléfono no puede superar los $maxLengthPhone dígitos.';
      }
      return null; // El valor es válido
    }
    // si no es telefono, validamos como email
    return validateEmail(value);
  }

  /// Valida una contraseña con una longitud mínima.
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es obligatoria.';
    }

    if (value.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres.';
    }
    return null; // El valor es válido
  }

  String? validatePasswordComplexity(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es obligatoria.';
    }

    if (value.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres.';
    }

    if (value.length > 25) {
      return 'La contraseña no puede superar los 25 caracteres.';
    }

    // Validación de complejidad:
    // 1. (?=.*[a-z]) - Al menos una minúscula
    // 2. (?=.*[A-Z]) - Al menos una mayúscula
    // 3. (?=.*\d) - Al menos un número
    // 4. (?=.*[@$!%*?&.,]) - Al menos uno de estos caracteres especiales
    final complexityRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&.,]).+$',
    );

    if (!complexityRegex.hasMatch(value)) {
      return 'La contraseña debe incluir mayúscula, minúscula, número y '
          r'un carácter especial (@$!%*?&.,).';
    }

    return null; // El valor es válido
  }

  /// Valida que dos contraseñas coincidan.
  String? validateConfirmPassword(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Confirma tu contraseña.';
    }

    if (password != confirmPassword) {
      return 'Las contraseñas no coinciden.';
    }

    return null; // El valor es válido
  }

  /// Valida el formato de un código postal (zip code).
  ///
  /// Acepta formatos:
  /// - 5 dígitos: 12345
  /// - 5 dígitos + guion + 4 dígitos: 12345-6789
  ///
  /// El campo es opcional, por lo que valores vacíos o null son válidos.
  ///
  /// Ejemplo de uso:
  /// ```dart
  /// final isValid = validateZipCode(zipCode);
  /// ```
  bool validateZipCode(String? zipCode) {
    if (zipCode == null || zipCode.isEmpty) {
      return true; // Optional field
    }
    return RegExp(r'^\d{5}(-\d{4})?$').hasMatch(zipCode) ||
        RegExp(r'^\d{5}$').hasMatch(zipCode);
  }

  /// Returns the error message for invalid zip code format.
  static String get zipCodeFormatError => 'Formato de código postal inválido';

  /// Returns the error message for required field selection.
  static String get requiredSelectionError => 'Selección obligatoria';

  /// Returns the error message for location search failure.
  static String get locationSearchError =>
      'No encontramos resultados para tu búsqueda. Intenta de nuevo';

  /// Helper común para manejar el evento onTapOutSide de los campos de texto.
  ///
  /// Oculta el teclado cuando el usuario toca fuera del campo.
  ///
  /// Ejemplo de uso:
  /// ```dart
  /// CustomTextField(
  ///   onTapOutSide: (event) => unfocusKeyboard(context),
  /// )
  /// ```
  void unfocusKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}
