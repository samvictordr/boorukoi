import 'package:material_ui/material_ui.dart';

/// Type ramp modeled after the iOS text styles, mapped onto Material roles so
/// existing `textTheme` call sites pick it up without changes.
///
/// | Material role  | iOS style     |
/// | -------------- | ------------- |
/// | headlineLarge  | Large Title   |
/// | headlineMedium | Title 1       |
/// | headlineSmall  | Title 2       |
/// | titleLarge     | Title 3       |
/// | titleMedium    | Headline      |
/// | titleSmall     | Subheadline   |
/// | bodyLarge      | Body          |
/// | bodyMedium     | Callout       |
/// | bodySmall      | Footnote      |
/// | labelLarge     | Button        |
/// | labelMedium    | Caption 1     |
/// | labelSmall     | Caption 2     |
abstract final class KurumiTypography {
  /// Sizes, weights and tracking only. `ThemeData` merges this onto the
  /// platform typography, which supplies font families and colors.
  static const textTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 56,
      height: 1.1,
      fontWeight: FontWeight.w700,
      letterSpacing: -1.2,
    ),
    displayMedium: TextStyle(
      fontSize: 45,
      height: 1.1,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.9,
    ),
    displaySmall: TextStyle(
      fontSize: 38,
      height: 1.15,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.6,
    ),
    headlineLarge: TextStyle(
      fontSize: 34,
      height: 1.2,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.4,
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      height: 1.2,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.35,
    ),
    headlineSmall: TextStyle(
      fontSize: 22,
      height: 1.25,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.3,
    ),
    titleLarge: TextStyle(
      fontSize: 20,
      height: 1.25,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.3,
    ),
    titleMedium: TextStyle(
      fontSize: 17,
      height: 1.3,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.4,
    ),
    titleSmall: TextStyle(
      fontSize: 15,
      height: 1.3,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.2,
    ),
    bodyLarge: TextStyle(
      fontSize: 17,
      height: 1.3,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.4,
    ),
    bodyMedium: TextStyle(
      fontSize: 15,
      height: 1.35,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.2,
    ),
    bodySmall: TextStyle(
      fontSize: 13,
      height: 1.35,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.1,
    ),
    labelLarge: TextStyle(
      fontSize: 15,
      height: 1.3,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.2,
    ),
    labelMedium: TextStyle(
      fontSize: 13,
      height: 1.3,
      fontWeight: FontWeight.w500,
      letterSpacing: -0.1,
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      height: 1.3,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.05,
    ),
  );
}
