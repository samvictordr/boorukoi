// Package imports:
import 'package:kurumi/kurumi.dart';
import 'package:kurumi/material.dart';
import 'package:test/test.dart';

// Project imports:
import 'package:boorusama/core/settings/src/pages/appearance/appearance_mode.dart';
import 'package:boorusama/core/settings/types.dart';
import 'package:boorusama/core/themes/configs/types.dart';

final _accent = ColorSettings.fromAccentColor(
  Colors.teal,
  brightness: Brightness.dark,
  dynamicSchemeVariant: DynamicSchemeVariant.tonalSpot,
  harmonizeWithPrimary: false,
);

final _builtIn = ColorSettings.fromPredefinedScheme('cyberpunk')!;

Settings _withColors(ColorSettings colors) =>
    Settings.defaultSettings.copyWith(colors: colors);

void main() {
  group('available appearance modes', () {
    final cases = [
      (
        name: 'free users can pick every mode',
        settings: _withColors(_builtIn),
        hasPremium: false,
        available: KurumiThemeMode.values.toSet(),
      ),
      (
        name: 'basic premium themes can pick every mode',
        settings: _withColors(basicColorSettings.first),
        hasPremium: true,
        available: KurumiThemeMode.values.toSet(),
      ),
      (
        name: 'accent themes can only be light or dark',
        settings: _withColors(_accent),
        hasPremium: true,
        available: {KurumiThemeMode.light, KurumiThemeMode.dark},
      ),
      (
        name: 'built-in themes have a fixed look',
        settings: _withColors(_builtIn),
        hasPremium: true,
        available: <KurumiThemeMode>{},
      ),
    ];

    for (final c in cases) {
      test(c.name, () {
        expect(
          AppearanceModeState.of(
            c.settings,
            hasPremium: c.hasPremium,
          ).available,
          c.available,
        );
      });
    }
  });

  test('free users change the theme mode', () {
    final settings = Settings.defaultSettings.withAppearanceMode(
      KurumiThemeMode.light,
      hasPremium: false,
    );

    expect(settings.themeMode, KurumiThemeMode.light);
    expect(
      AppearanceModeState.of(settings, hasPremium: false).selected,
      KurumiThemeMode.light,
    );
  });

  group('basic premium themes switch to the matching basic theme', () {
    for (final mode in KurumiThemeMode.values) {
      test('selects $mode', () {
        final settings = _withColors(basicColorSettings.first)
            .withAppearanceMode(mode, hasPremium: true);

        expect(
          AppearanceModeState.of(settings, hasPremium: true).selected,
          mode,
        );
      });
    }
  });

  test('basic premium themes keep dynamic color when switching mode', () {
    final settings = _withColors(
      basicColorSettings.first.copyWith(enableDynamicColoring: true),
    ).withAppearanceMode(KurumiThemeMode.dark, hasPremium: true);

    expect(settings.colors?.enableDynamicColoring, isTrue);
  });

  test('accent themes keep their color when switching to light', () {
    final settings = _withColors(_accent).withAppearanceMode(
      KurumiThemeMode.light,
      hasPremium: true,
    );

    expect(settings.colors?.name, _accent.name);
    expect(settings.colors?.brightness, Brightness.light);
  });

  test('built-in themes ignore mode changes', () {
    final settings = _withColors(_builtIn);

    expect(
      settings.withAppearanceMode(KurumiThemeMode.light, hasPremium: true),
      settings,
    );
  });
}
