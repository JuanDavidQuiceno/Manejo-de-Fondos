import 'package:flutter/material.dart';

extension StringColorExtension on String {
  /// Converts a hex color string to a Color object.
  /// Supported formats:
  /// - #RRGGBB (6 chars) -> fully opaque
  /// - #AARRGGBB (8 chars) -> with alpha
  /// - RRGGBB (6 chars)
  /// - AARRGGBB (8 chars)
  Color toColor() {
    final hexString = this;
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) {
      buffer.write('ff'); // Add full opacity by default if missing
    }
    buffer.write(hexString.replaceFirst('#', ''));

    try {
      return Color(int.parse(buffer.toString(), radix: 16));
    } on Exception catch (_) {
      // Return black or transparent as fallback if parsing fails
      return Colors.black;
    }
  }

  /// Removes trailing `.0` from a string representation of a number.
  String get removeDecimalZero {
    if (endsWith('.0')) {
      return substring(0, length - 2);
    }
    return this;
  }
}
