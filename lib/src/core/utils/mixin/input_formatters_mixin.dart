import 'package:flutter/services.dart';

/// Formatea un número para mostrar en campo de moneda (formato latino).
/// Ejemplo: 1234.56 → "1.234,56"
String formatCurrencyForDisplay(double value, {int decimalDigits = 2}) {
  if (value.isNaN || value.isInfinite) return '0,00';
  final parts = value.toStringAsFixed(decimalDigits).split('.');
  final intStr = parts[0];
  final buffer = StringBuffer();
  for (var i = 0; i < intStr.length; i++) {
    if (i > 0 && (intStr.length - i) % 3 == 0) buffer.write('.');
    buffer.write(intStr[i]);
  }
  buffer.write(',${parts[1]}');
  return buffer.toString();
}

/// Configuración para formateo de moneda.
class CurrencyFormatConfig {
  const CurrencyFormatConfig({
    this.decimalSeparator = '.',
    this.thousandsSeparator = ',',
    this.maxDecimalDigits = 2,
  });

  final String decimalSeparator;
  final String thousandsSeparator;
  final int maxDecimalDigits;

  /// Formato US: 1,234.56
  static const us = CurrencyFormatConfig();

  /// Formato latino: 1.234,56
  static const latin = CurrencyFormatConfig(
    decimalSeparator: ',',
    thousandsSeparator: '.',
  );
}

/// Máximo de dígitos permitidos (12 = hasta 9.999.999.999,99).
const int _maxCurrencyDigits = 15;

/// Máximo valor en céntimos según [_maxCurrencyDigits].
int get _maxCents => int.parse(''.padLeft(_maxCurrencyDigits, '9'));

/// Formateador de moneda estilo caja registradora: cada dígito se añade por la
/// derecha y se desplazan hacia la izquierda, siempre con 2 decimales visibles.
///
/// Ejemplo: vacío → "0,00" | "1" → "0,01" | "11" → "0,11" | "112" → "1,12" |
/// "1123" → "11,23" | "11234" → "112,34"
/// No permite más de 12 dígitos (máx. 9.999.999.999,99).
class CurrencyInputFormatter extends TextInputFormatter {
  CurrencyInputFormatter({this.config = CurrencyFormatConfig.latin});

  final CurrencyFormatConfig config;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var digits = _extractDigits(newValue.text);
    if (digits.length > _maxCurrencyDigits) {
      digits = digits.substring(0, _maxCurrencyDigits);
    }
    final cents = digits.isEmpty ? 0 : int.tryParse(digits) ?? 0;
    final formatted = _formatCents(cents);

    if (formatted == newValue.text) return newValue;

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  /// Extrae solo dígitos (el valor se interpreta como céntimos).
  String _extractDigits(String input) {
    final buffer = StringBuffer();
    for (final c in input.split('')) {
      if (RegExp(r'^\d$').hasMatch(c)) buffer.write(c);
    }
    return buffer.toString();
  }

  String _formatCents(int cents) {
    final clamped = cents.clamp(0, _maxCents);
    final intPart = clamped ~/ 100;
    final decPart = clamped % 100;
    final intStr = intPart.toString();
    final formattedInt = _addThousandsSeparator(intStr);
    final decStr = decPart.toString().padLeft(2, '0');
    return '$formattedInt${config.decimalSeparator}$decStr';
  }

  String _addThousandsSeparator(String value) {
    if (value.length <= 3) return value;
    final buf = StringBuffer();
    var count = 0;
    for (var i = value.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) {
        buf.write(config.thousandsSeparator);
      }
      buf.write(value[i]);
      count++;
    }
    return buf.toString().split('').reversed.join();
  }
}

/// Elimina ceros iniciales del input (ej. "007" → "7", "010" → "10").
///
/// Útil para campos de cantidad donde los ceros a la izquierda no tienen
/// significado.
class LeadingZeroRemover extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;

    final parsed = int.tryParse(text);
    if (parsed == null) return newValue;

    final normalized = parsed.toString();
    if (normalized == text) return newValue;

    return TextEditingValue(
      text: normalized,
      selection: TextSelection.collapsed(offset: normalized.length),
    );
  }
}

/// Formatea un número como entero con separador de miles sin decimales
/// (formato latino).
/// Ejemplo: 1234 → "1.234", 1000000 → "1.000.000"
String formatIntForDisplay(num value, {String thousandsSeparator = '.'}) {
  final intValue = value.toInt();
  final str = intValue.abs().toString();
  if (str.length <= 3) return intValue < 0 ? '-$str' : str;
  final buffer = StringBuffer();
  if (intValue < 0) buffer.write('-');
  for (var i = 0; i < str.length; i++) {
    if (i > 0 && (str.length - i) % 3 == 0) buffer.write(thousandsSeparator);
    buffer.write(str[i]);
  }
  return buffer.toString();
}

/// Máximo de dígitos permitidos para enteros (9 = hasta 999.999.999).
const int _maxIntegerDigits = 9;

/// Formateador de entrada para enteros con separador de miles (sin decimales).
/// Ejemplo: "1234" → "1.234", "1000000" → "1.000.000"
/// Limita a [maxDigits] dígitos (por defecto 9 → máx. 999.999.999).
class IntegerThousandsFormatter extends TextInputFormatter {
  IntegerThousandsFormatter({
    this.thousandsSeparator = '.',
    this.maxDigits = _maxIntegerDigits,
  });

  final String thousandsSeparator;
  final int maxDigits;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var digits = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.isEmpty) {
      return const TextEditingValue(
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    if (digits.length > maxDigits) {
      digits = digits.substring(0, maxDigits);
    }

    final parsed = int.tryParse(digits);
    if (parsed == null) return oldValue;

    final formatted = formatIntForDisplay(
      parsed,
      thousandsSeparator: thousandsSeparator,
    );

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Mixin para reutilizar formateadores de input en widgets.
///
/// Ejemplo de uso:
/// ```dart
/// class _MyWidgetState extends State<MyWidget> with InputFormattersMixin {
///   @override
///   Widget build(BuildContext context) {
///     return CustomTextField(
///       inputFormatters: [leadingZeroRemover],
///       ...
///     );
///   }
/// }
/// ```
mixin InputFormattersMixin {
  /// Formateador que elimina ceros iniciales en inputs numéricos.
  TextInputFormatter get leadingZeroRemover => LeadingZeroRemover();

  /// Formateador de moneda con separador de miles y decimales.
  /// Formato latino por defecto: coma para decimales, punto para miles
  /// (1.234,56).
  TextInputFormatter currencyFormatter({
    CurrencyFormatConfig config = CurrencyFormatConfig.latin,
  }) => CurrencyInputFormatter(config: config);

  /// Formateador de enteros con separador de miles (sin decimales).
  TextInputFormatter integerThousandsFormatter({
    String thousandsSeparator = '.',
  }) => IntegerThousandsFormatter(thousandsSeparator: thousandsSeparator);
}
