import 'dart:ui';

import 'package:dashboard/src/core/theme/app_colors.dart';

/// Utilidad centralizada para parsear valores desde JSON (dynamic).
/// Acepta int, num, String y null; evita duplicar lógica en modelos.
abstract final class JsonParse {
  JsonParse._();

  /// Parsea a [double]; null si no es válido.
  static double? parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  /// Parsea a [double]; devuelve 0.0 si null o inválido.
  static double parseDoubleOrZero(dynamic value) {
    return parseDouble(value) ?? 0.0;
  }

  /// Parsea a [int]; null si no es válido. No acepta decimales en String.
  static int? parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  /// Parsea a [int]; devuelve 0 si null o inválido.
  static int parseIntOrZero(dynamic value) {
    return parseInt(value) ?? 0;
  }

  /// Parsea cantidad: acepta int, num o String con decimales (ej. "1.00").
  static num parseQuantity(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value;
    if (value is String) {
      return double.tryParse(value) ?? 0;
    }
    return 0;
  }

  static Color hexToColor(String? hex) {
    try {
      if (hex == null) throw const FormatException('Null hex color');

      var hexTemp = hex.replaceAll('#', '');

      // Si no incluye opacidad, se asume FF (totalmente opaco)
      if (hexTemp.length == 6) {
        hexTemp = 'FF$hexTemp';
      } else if (hexTemp.length != 8) {
        throw const FormatException('Invalid hex color format');
      }

      return Color(int.parse(hexTemp, radix: 16));
    } on FormatException {
      return AppColors.primary; // Retorna un color por defecto en caso de error
    }
  }
}
