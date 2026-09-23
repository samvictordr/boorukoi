// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i18n/i18n.dart';
import 'package:kurumi/kurumi.dart';
import 'package:kurumi/material.dart';
import 'package:material_symbols_icons/symbols.dart';

// Project imports:
import '../../../../premiums/providers.dart';
import '../../../../themes/theme/types.dart';
import '../../providers/settings_notifier.dart';
import '../../providers/settings_provider.dart';
import 'appearance_mode.dart';

/// Light / dark / black / automatic picker with a miniature preview of each,
/// modeled after the iOS Display & Brightness screen.
class AppearanceModePicker extends ConsumerWidget {
  const AppearanceModePicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final hasPremium = ref.watch(hasPremiumProvider);
    final state = AppearanceModeState.of(settings, hasPremium: hasPremium);

    return KurumiSettingsSection(
      header: context.t.settings.theme.appearance,
      footer: state.isFixed ? context.t.settings.theme.fixed_appearance : null,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: KurumiSpacing.sm,
            vertical: KurumiSpacing.lg,
          ),
          child: Row(
            children: [
              for (final mode in _order)
                Expanded(
                  child: _ModeOption(
                    mode: mode,
                    selected: state.selected == mode,
                    enabled: state.available.contains(mode),
                    onTap: () {
                      context.kurumiBehavior.provideSelectionFeedback();
                      ref
                          .read(settingsNotifierProvider.notifier)
                          .updateSettings(
                            settings.withAppearanceMode(
                              mode,
                              hasPremium: hasPremium,
                            ),
                          );
                    },
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

const _order = [
  KurumiThemeMode.light,
  KurumiThemeMode.dark,
  KurumiThemeMode.amoledDark,
  KurumiThemeMode.system,
];

class _ModeOption extends StatelessWidget {
  const _ModeOption({
    required this.mode,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  final KurumiThemeMode mode;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Kurumi.themeOf(context);
    final colorScheme = theme.colorScheme;
    final label = mode.localize(context);

    return Semantics(
      button: true,
      selected: selected,
      enabled: enabled,
      label: label,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: enabled && !selected ? onTap : null,
        child: AnimatedOpacity(
          duration: KurumiMotion.fast,
          opacity: enabled ? 1 : 0.35,
          child: Column(
            children: [
              AnimatedContainer(
                duration: context.kurumiBehavior.effectiveDuration(
                  KurumiMotion.standard,
                ),
                curve: KurumiMotion.standardCurve,
                padding: const EdgeInsets.all(3),
                decoration: ShapeDecoration(
                  shape: KurumiShapes.radius(
                    KurumiRadius.md,
                    side: BorderSide(
                      color: selected
                          ? colorScheme.primary
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: _Preview(mode: mode),
              ),
              const SizedBox(height: KurumiSpacing.sm),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelMedium,
              ),
              const SizedBox(height: KurumiSpacing.xs),
              Icon(
                selected ? Symbols.check_circle : Symbols.circle,
                fill: selected ? 1 : 0,
                size: 22,
                color: selected
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Preview extends StatelessWidget {
  const _Preview({required this.mode});

  final KurumiThemeMode mode;

  @override
  Widget build(BuildContext context) {
    final radius = KurumiRadius.concentric(KurumiRadius.md, 3);

    return ClipRSuperellipse(
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      child: AspectRatio(
        aspectRatio: 0.62,
        child: switch (mode) {
          KurumiThemeMode.light => const _Screen(palette: _lightPalette),
          KurumiThemeMode.dark => const _Screen(palette: _darkPalette),
          KurumiThemeMode.amoledDark => const _Screen(palette: _blackPalette),
          KurumiThemeMode.system => const Stack(
            fit: StackFit.expand,
            children: [
              _Screen(palette: _lightPalette),
              ClipPath(
                clipper: _DiagonalClipper(),
                child: _Screen(palette: _darkPalette),
              ),
            ],
          ),
        },
      ),
    );
  }
}

typedef _Palette = ({Color background, Color card, Color line});

const _Palette _lightPalette = (
  background: Color(0xFFF2F2F7),
  card: Color(0xFFFFFFFF),
  line: Color(0xFFD1D1D6),
);
const _Palette _darkPalette = (
  background: Color(0xFF1C1C1E),
  card: Color(0xFF2C2C2E),
  line: Color(0xFF48484A),
);
const _Palette _blackPalette = (
  background: Color(0xFF000000),
  card: Color(0xFF1C1C1E),
  line: Color(0xFF3A3A3C),
);

/// A tiny stand-in for the app: a search pill over a grid of posts.
class _Screen extends StatelessWidget {
  const _Screen({required this.palette});

  final _Palette palette;

  @override
  Widget build(BuildContext context) {
    final primary = Kurumi.themeOf(context).colorScheme.primary;

    return ColoredBox(
      color: palette.background,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Column(
          children: [
            Container(
              height: 8,
              decoration: ShapeDecoration(
                shape: const StadiumBorder(),
                color: palette.card,
              ),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                padding: EdgeInsets.zero,
                children: [
                  for (var i = 0; i < 6; i++)
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: i == 0
                            ? primary.withValues(alpha: 0.6)
                            : palette.line,
                        borderRadius: KurumiBorderRadius.xs / 2,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Container(
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: ShapeDecoration(
                shape: const StadiumBorder(),
                color: palette.card,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DiagonalClipper extends CustomClipper<Path> {
  const _DiagonalClipper();

  @override
  Path getClip(Size size) => Path()
    ..moveTo(size.width, 0)
    ..lineTo(size.width, size.height)
    ..lineTo(0, size.height)
    ..close();

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
