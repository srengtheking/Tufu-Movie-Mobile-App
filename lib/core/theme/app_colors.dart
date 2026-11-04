import 'package:flutter/material.dart';

/// Brand colors shared by light and dark themes.
class AppColors {
  AppColors._();

  /// Solid button / chip red.
  static const primary = Color(0xFFD20012);

  /// Logo & coin red (slightly brighter).
  static const brand = Color(0xFFE50914);

  /// Link / destructive text red.
  static const accent = Color(0xFFFF4D57);

  static const white = Colors.white;
}

/// Theme-dependent surface & text colors, read with `context.palette`.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  final Color background;
  final Color surface; // hero areas, list cards
  final Color card; // posters, inputs
  final Color button; // secondary buttons
  final Color chip;
  final Color border;
  final Color divider;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color link;

  const AppPalette({
    required this.background,
    required this.surface,
    required this.card,
    required this.button,
    required this.chip,
    required this.border,
    required this.divider,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.link,
  });

  static const dark = AppPalette(
    background: Color(0xFF0A0A0A),
    surface: Color(0xFF1B1B1B),
    card: Color(0xFF212121),
    button: Color(0xFF2A2A2A),
    chip: Color(0xFF212121),
    border: Color(0xFF3A3A3A),
    divider: Color(0xFF2A2A2A),
    textPrimary: Color(0xFFF5F5F5),
    textSecondary: Color(0xFFB3B3B3),
    textMuted: Color(0xFF8A8A8A),
    link: AppColors.accent,
  );

  static const light = AppPalette(
    background: Color(0xFFFFFFFF),
    surface: Color(0xFFEDEDED),
    card: Color(0xFFF0F0F0),
    button: Color(0xFFE3E3E3),
    chip: Color(0xFFEEEEEE),
    border: Color(0xFFC8C8C8),
    divider: Color(0xFFDDDDDD),
    textPrimary: Color(0xFF111111),
    textSecondary: Color(0xFF5C5C5C),
    textMuted: Color(0xFF7A7A7A),
    link: AppColors.primary,
  );

  @override
  AppPalette copyWith({
    Color? background,
    Color? surface,
    Color? card,
    Color? button,
    Color? chip,
    Color? border,
    Color? divider,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? link,
  }) {
    return AppPalette(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      card: card ?? this.card,
      button: button ?? this.button,
      chip: chip ?? this.chip,
      border: border ?? this.border,
      divider: divider ?? this.divider,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      link: link ?? this.link,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      card: Color.lerp(card, other.card, t)!,
      button: Color.lerp(button, other.button, t)!,
      chip: Color.lerp(chip, other.chip, t)!,
      border: Color.lerp(border, other.border, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      link: Color.lerp(link, other.link, t)!,
    );
  }
}

extension AppPaletteX on BuildContext {
  AppPalette get palette =>
      Theme.of(this).extension<AppPalette>() ?? AppPalette.dark;
}
