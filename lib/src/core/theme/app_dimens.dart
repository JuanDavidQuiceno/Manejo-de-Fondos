import 'package:flutter/material.dart';

/// Define los valores de espaciado (padding, margin, Sizedbox)
class AppDimens {
  static const double defaultHorizontal = p16;
  // --- Espaciado (Padding, Margin) ---
  static const double p4 = 4;
  static const double p8 = 8;
  static const double p10 = 10;
  static const double p12 = 12;
  static const double p16 = 16;
  static const double p20 = 20;
  static const double p24 = 24;
  static const double p28 = 28;
  static const double p30 = 30;
  static const double p32 = 32;
  static const double p40 = 40;
  static const double p42 = 42;
  static const double p48 = 48;
}

/// Define los valores de radio de borde
class AppRadius {
  // --- Radios (BorderRadius) ---
  /// Radio de 4.0
  static final r4 = BorderRadius.circular(4);

  /// Radio de 8.0
  static final r8 = BorderRadius.circular(8);

  /// Radio de 12.0
  static final r12 = BorderRadius.circular(12);

  /// Radio de 16.0
  static final r16 = BorderRadius.circular(16);

  /// Radio de 24.0
  static final r24 = BorderRadius.circular(24);

  /// Radio de 100 (para círculos)
  static final rMax = BorderRadius.circular(100);
}
