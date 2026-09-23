import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';

const kKurumiEnableHeroTransition = true;

class KurumiHero extends StatelessWidget {
  const KurumiHero({
    required this.tag,
    required this.child,
    super.key,
    this.borderRadius = BorderRadius.zero,
  });

  final Widget child;
  final String? tag;

  /// Corner radius of this hero at rest. During a flight the clip morphs
  /// between the radii of both heroes.
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final reduceMotion =
        KurumiTheme.maybeBehaviorOf(context)?.reduceMotion ?? false;
    final heroTag = tag;

    return kKurumiEnableHeroTransition && heroTag != null && !reduceMotion
        ? _HeroRadius(
            borderRadius: borderRadius,
            child: Hero(
              tag: heroTag,
              createRectTween: (begin, end) =>
                  KurumiLinearRectTween(begin: begin, end: end),
              flightShuttleBuilder: _flightShuttleBuilder,
              child: child,
            ),
          )
        : child;
  }
}

/// Always flies the hero of the top-most route (e.g. the full image rather
/// than the grid thumbnail), cropped to the flight rect like `BoxFit.cover`,
/// so the thumbnail's crop opens up into the full image.
Widget _flightShuttleBuilder(
  BuildContext flightContext,
  Animation<double> animation,
  HeroFlightDirection flightDirection,
  BuildContext fromHeroContext,
  BuildContext toHeroContext,
) {
  final (bottomContext, topContext) = switch (flightDirection) {
    HeroFlightDirection.push => (fromHeroContext, toHeroContext),
    HeroFlightDirection.pop => (toHeroContext, fromHeroContext),
  };

  final topHero = topContext.widget as Hero;
  final topSize = switch (topContext.findRenderObject()) {
    final RenderBox box when box.hasSize => box.size,
    _ => null,
  };
  final bottomRadius = _HeroRadius.of(bottomContext);
  final topRadius = _HeroRadius.of(topContext);

  return AnimatedBuilder(
    animation: animation,
    builder: (context, child) => ClipRSuperellipse(
      borderRadius:
          BorderRadius.lerp(bottomRadius, topRadius, animation.value) ??
          BorderRadius.zero,
      child: child,
    ),
    child: switch (topSize) {
      final Size size => FittedBox(
        fit: BoxFit.cover,
        child: SizedBox.fromSize(
          size: size,
          child: topHero.child,
        ),
      ),
      null => topHero.child,
    },
  );
}

class _HeroRadius extends InheritedWidget {
  const _HeroRadius({
    required this.borderRadius,
    required super.child,
  });

  final BorderRadius borderRadius;

  static BorderRadius of(BuildContext context) =>
      context.getInheritedWidgetOfExactType<_HeroRadius>()?.borderRadius ??
      BorderRadius.zero;

  @override
  bool updateShouldNotify(_HeroRadius oldWidget) =>
      borderRadius != oldWidget.borderRadius;
}

class KurumiLinearRectTween extends RectTween {
  KurumiLinearRectTween({super.begin, super.end});

  @override
  Rect lerp(double t) {
    final rect = Rect.lerp(begin, end, t);

    if (rect == null) {
      return Rect.zero;
    }

    return rect;
  }
}
