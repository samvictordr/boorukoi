import 'package:flutter/animation.dart';

/// Shared motion language. Prefer springs for anything the user can interrupt
/// or drive with a gesture, and the named curves for fire-and-forget changes.
abstract final class KurumiMotion {
  static const fast = Duration(milliseconds: 150);
  static const standard = Duration(milliseconds: 250);
  static const emphasized = Duration(milliseconds: 400);

  static const Curve standardCurve = Curves.easeOutCubic;
  static const Curve emphasizedCurve = Curves.easeInOutCubicEmphasized;
  static const Curve exitCurve = Curves.easeInCubic;

  /// Critically damped, no overshoot. Good default for layout changes.
  static final SpringDescription smoothSpring =
      SpringDescription.withDurationAndBounce(
        duration: standard,
      );

  /// Slight overshoot for things that should feel alive: selection, toggles,
  /// items popping into place.
  static final SpringDescription snappySpring =
      SpringDescription.withDurationAndBounce(
        duration: const Duration(milliseconds: 300),
        bounce: 0.15,
      );

  /// Larger, slower settle for full-screen transitions and dismissals.
  static final SpringDescription emphasizedSpring =
      SpringDescription.withDurationAndBounce(
        duration: emphasized,
        bounce: 0.1,
      );
}
