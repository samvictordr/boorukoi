// Package imports:
import 'package:equatable/equatable.dart';
import 'package:kurumi/kurumi.dart';
import 'package:kurumi/material.dart';

// Project imports:
import '../../../../themes/configs/types.dart';
import '../../types/settings.dart';

/// Which light/dark choices apply to the theme currently in use.
///
/// Free users always pick from the plain theme modes. Premium users with a
/// custom theme can only switch modes their theme supports, and some themes
/// have a fixed look.
class AppearanceModeState extends Equatable {
  const AppearanceModeState({
    required this.selected,
    required this.available,
  });

  factory AppearanceModeState.of(
    Settings settings, {
    required bool hasPremium,
  }) => switch (_themeSource(settings, hasPremium: hasPremium)) {
    null => AppearanceModeState(
      selected: settings.themeMode,
      available: KurumiThemeMode.values.toSet(),
    ),
    ColorSettings(schemeType: SchemeType.basic) && final colors =>
      AppearanceModeState(
        selected: _basicModeOf(colors),
        available: KurumiThemeMode.values.toSet(),
      ),
    ColorSettings(schemeType: SchemeType.accent) && final colors =>
      AppearanceModeState(
        selected: switch (colors.brightness) {
          Brightness.light => KurumiThemeMode.light,
          _ => KurumiThemeMode.dark,
        },
        available: const {KurumiThemeMode.light, KurumiThemeMode.dark},
      ),
    _ => const AppearanceModeState(selected: null, available: {}),
  };

  /// Null when the theme has a fixed look.
  final KurumiThemeMode? selected;
  final Set<KurumiThemeMode> available;

  bool get isFixed => available.isEmpty;

  @override
  List<Object?> get props => [selected, available];
}

extension AppearanceModeSettingsX on Settings {
  /// Applies [mode] to whichever theme source is active, leaving the rest of
  /// the theme (accent color, dynamic color) untouched.
  Settings withAppearanceMode(
    KurumiThemeMode mode, {
    required bool hasPremium,
  }) => switch (_themeSource(this, hasPremium: hasPremium)) {
    null => copyWith(themeMode: mode),
    ColorSettings(schemeType: SchemeType.basic) && final colors => copyWith(
      colors: _basicColorsFor(mode, previous: colors),
    ),
    ColorSettings(schemeType: SchemeType.accent) && final colors
        when mode == KurumiThemeMode.light || mode == KurumiThemeMode.dark =>
      copyWith(
        colors: colors.copyWith(
          brightness: mode.isLight ? Brightness.light : Brightness.dark,
        ),
      ),
    _ => this,
  };
}

ColorSettings? _themeSource(Settings settings, {required bool hasPremium}) =>
    hasPremium ? settings.colors : null;

KurumiThemeMode _basicModeOf(ColorSettings colors) =>
    (colors.followSystemDarkMode ?? false)
    ? KurumiThemeMode.system
    : switch (colors.name) {
        'boorusama_light' => KurumiThemeMode.light,
        'boorusama_dark' => KurumiThemeMode.dark,
        _ => KurumiThemeMode.amoledDark,
      };

ColorSettings _basicColorsFor(
  KurumiThemeMode mode, {
  required ColorSettings previous,
}) {
  final basic = basicColorSettings.firstWhere(
    (colors) => _basicModeOf(colors) == mode,
  );

  return basic.copyWith(
    enableDynamicColoring: previous.enableDynamicColoring,
  );
}
