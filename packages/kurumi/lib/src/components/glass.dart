import 'dart:ui';

import 'package:material_ui/material_ui.dart';

enum KurumiGlassThickness {
  thin(blur: 12, opacity: 0.55),
  regular(blur: 24, opacity: 0.7),
  thick(blur: 32, opacity: 0.82);

  const KurumiGlassThickness({
    required this.blur,
    required this.opacity,
  });

  final double blur;
  final double opacity;
}

/// Translucent blurred material for chrome that floats above content, such as
/// the navigation pill, toolbars and overlays.
class KurumiGlass extends StatelessWidget {
  const KurumiGlass({
    required this.child,
    super.key,
    this.shape = const StadiumBorder(),
    this.thickness = KurumiGlassThickness.regular,
    this.tint,
    this.showBorder = true,
    this.elevated = false,
  });

  final Widget child;
  final OutlinedBorder shape;
  final KurumiGlassThickness thickness;
  final Color? tint;
  final bool showBorder;

  /// Adds a soft shadow so the surface reads as floating above content.
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final highContrast = MediaQuery.maybeHighContrastOf(context) ?? false;
    final isDark = colorScheme.brightness == Brightness.dark;

    final baseColor = tint ?? colorScheme.surfaceContainer;
    final color = highContrast
        ? baseColor
        : baseColor.withValues(alpha: thickness.opacity);

    final borderSide = showBorder
        ? BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.12)
                : Colors.black.withValues(alpha: 0.06),
            width: 0.5,
          )
        : BorderSide.none;

    final effectiveShape = shape.copyWith(side: borderSide);
    final content = KurumiGlassScope(child: child);

    final surface = ClipPath(
      clipper: ShapeBorderClipper(shape: shape),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: thickness.blur,
          sigmaY: thickness.blur,
        ),
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: color,
            shape: effectiveShape,
          ),
          child: content,
        ),
      ),
    );

    return elevated
        ? DecoratedBox(
            decoration: ShapeDecoration(
              shape: shape,
              shadows: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: surface,
          )
        : surface;
  }
}

/// Marks content that sits on a [KurumiGlass] surface, so controls inside can
/// drop their own fills and let the material show through.
class KurumiGlassScope extends InheritedWidget {
  const KurumiGlassScope({
    required super.child,
    super.key,
  });

  static bool isInside(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<KurumiGlassScope>() != null;

  @override
  bool updateShouldNotify(KurumiGlassScope oldWidget) => false;
}

/// Full-bleed glass for edge-to-edge bars such as app bars, where content
/// scrolls underneath.
class KurumiGlassBar extends StatelessWidget {
  const KurumiGlassBar({
    super.key,
    this.thickness = KurumiGlassThickness.regular,
    this.child,
  });

  final KurumiGlassThickness thickness;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final highContrast = MediaQuery.maybeHighContrastOf(context) ?? false;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: thickness.blur,
          sigmaY: thickness.blur,
        ),
        child: ColoredBox(
          color: highContrast
              ? colorScheme.surface
              : colorScheme.surface.withValues(alpha: thickness.opacity),
          child: child ?? const SizedBox.expand(),
        ),
      ),
    );
  }
}
