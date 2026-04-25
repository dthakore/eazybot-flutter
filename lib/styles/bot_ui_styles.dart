import 'package:flutter/material.dart';

class BotUiFontSize {
  /// Tiny captions (timestamps, meta)
  static const double xxs = 9;
  static const double xs = 10;
  static const double sm = 11;
  static const double md = 12;
  static const double base = 14;
  /// Emphasized numbers in compact insight cards
  static const double value = 15;
  static const double lg = 16;
  static const double xl = 18;
}

class BotUiRadius {
  static const double sm = 4;
  static const double md = 6;
  static const double lg = 8;
  static const double xl = 10;
  static const double xxl = 12;
  /// Pills and medium chips (e.g. tab badges)
  static const double chip = 16;
  static const double pill = 40;
  static const double card = 14;
  /// Profile / circular image masks
  static const double avatar = 100;
}

class BotUiCardStyle {
  static const EdgeInsets contentPadding = EdgeInsets.symmetric(
    horizontal: 10,
    vertical: 6,
  );
}
