import 'dart:math' as math;

import 'package:flutter/painting.dart';

/// Corner radius scale. Every rounded surface should pick one of these steps.
abstract final class KurumiRadius {
  static const double xs = 6;
  static const double sm = 10;
  static const double md = 14;
  static const double lg = 20;
  static const double xl = 28;

  /// Radius for a shape nested inside another rounded shape, so both corners
  /// share the same center and look optically parallel.
  static double concentric(double outer, double padding) =>
      math.max(0, outer - padding);
}

abstract final class KurumiBorderRadius {
  static const xs = BorderRadius.all(Radius.circular(KurumiRadius.xs));
  static const sm = BorderRadius.all(Radius.circular(KurumiRadius.sm));
  static const md = BorderRadius.all(Radius.circular(KurumiRadius.md));
  static const lg = BorderRadius.all(Radius.circular(KurumiRadius.lg));
  static const xl = BorderRadius.all(Radius.circular(KurumiRadius.xl));
  static const sheet = BorderRadius.vertical(
    top: Radius.circular(KurumiRadius.xl),
  );

  /// Pill ends for any height.
  static const full = BorderRadius.all(Radius.circular(999));
}

/// Continuous-corner (superellipse) shapes matching [KurumiRadius].
abstract final class KurumiShapes {
  static const xs = RoundedSuperellipseBorder(
    borderRadius: KurumiBorderRadius.xs,
  );
  static const sm = RoundedSuperellipseBorder(
    borderRadius: KurumiBorderRadius.sm,
  );
  static const md = RoundedSuperellipseBorder(
    borderRadius: KurumiBorderRadius.md,
  );
  static const lg = RoundedSuperellipseBorder(
    borderRadius: KurumiBorderRadius.lg,
  );
  static const xl = RoundedSuperellipseBorder(
    borderRadius: KurumiBorderRadius.xl,
  );
  static const sheet = RoundedSuperellipseBorder(
    borderRadius: KurumiBorderRadius.sheet,
  );
  static const full = StadiumBorder();

  static RoundedSuperellipseBorder radius(
    double radius, {
    BorderSide side = BorderSide.none,
  }) => RoundedSuperellipseBorder(
    borderRadius: BorderRadius.all(Radius.circular(radius)),
    side: side,
  );
}
