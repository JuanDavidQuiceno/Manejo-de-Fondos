/// Mixin para parsear valores desde texto de inputs
/// (ej. TextEditingController).
/// Normaliza coma a punto para decimales y evita duplicar lógica de parseo.
mixin ParseInputMixin {
  /// Normaliza el String para parseo numérico (reemplaza coma por punto).
  String _normalizeDecimalInput(String? text) {
    if (text == null || text.isEmpty) return '';
    return text.trim().replaceAll(',', '.');
  }

  /// Parsea a [int]; devuelve [defaultValue] si null o inválido.
  int parseIntInput(String? text, {int defaultValue = 0}) {
    if (text == null || text.isEmpty) return defaultValue;
    return int.tryParse(text.trim()) ?? defaultValue;
  }

  /// Parsea a [int] desde texto con separador de miles (ej. "1.234" → 1234).
  /// Elimina puntos (separador de miles) antes de parsear.
  int parseFormattedIntInput(String? text, {int defaultValue = 0}) {
    if (text == null || text.isEmpty) return defaultValue;
    final cleaned = text.trim().replaceAll('.', '');
    return int.tryParse(cleaned) ?? defaultValue;
  }

  /// Parsea a [double]; devuelve [defaultValue] si null o inválido.
  /// Acepta coma o punto como separador decimal.
  double parseDoubleInput(String? text, {double? defaultValue}) {
    final normalized = _normalizeDecimalInput(text);
    if (normalized.isEmpty) return defaultValue ?? 0.0;
    return double.tryParse(normalized) ?? defaultValue ?? 0.0;
  }

  /// Parsea texto con formato de moneda.
  /// Formato latino: "1.234,56" (coma = decimales, punto = miles).
  /// Elimina separadores de miles y normaliza el decimal antes de parsear.
  double parseCurrencyInput(String? text, {double? defaultValue}) {
    if (text == null || text.isEmpty) return defaultValue ?? 0.0;
    final t = text.trim();
    // Formato latino: quitar punto (miles), reemplazar coma por punto (decimal)
    final normalized = t.replaceAll('.', '').replaceAll(',', '.');
    return double.tryParse(normalized) ?? defaultValue ?? 0.0;
  }

  /// Parsea cantidad y precio en un solo paso.
  /// Retorna [Record] `(qty, price)` para uso directo en la vista.
  ///
  /// Ejemplo:
  /// ```dart
  /// final (qty, price) = parseQuantityAndPrice(
  ///   _qtyController.text,
  ///   _priceController.text,
  ///   qtyDefault: 1,
  ///   priceDefault: widget.unitPrice,
  /// );
  /// if (qty > 0) widget.onAdd(qty, price);
  /// ```
  (num qty, double price) parseQuantityAndPrice(
    String? qtyText,
    String? priceText, {
    num qtyDefault = 0,
    double priceDefault = 0.0,
  }) {
    return (
      parseDoubleInput(qtyText, defaultValue: qtyDefault.toDouble()),
      parseDoubleInput(priceText, defaultValue: priceDefault),
    );
  }
}
