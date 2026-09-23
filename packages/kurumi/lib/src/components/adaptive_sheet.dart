// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:material_ui/material_ui.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../foundation/screen.dart';
import '../theme/color_tokens.dart';
import '../theme/motion.dart';
import '../theme/shapes.dart';
import '../theme/spacing.dart';

Future<T?> kurumiShowAdaptiveSheet<T>(
  BuildContext context, {
  required Widget Function(BuildContext context) builder,
  bool expand = false,
  double? width,
  Color? backgroundColor,
  RouteSettings? settings,
}) {
  if (KurumiScreen.of(context).size == KurumiScreenSize.small) {
    return showModalBottomSheet<T>(
      useSafeArea: true,
      routeSettings: settings,
      context: context,
      backgroundColor: backgroundColor,
      isScrollControlled: expand,
      builder: builder,
    );
  } else {
    return kurumiShowSideSheetFromRight<T>(
      settings: settings,
      width: width ?? 320,
      body: MediaQuery.removePadding(
        context: context,
        removeLeft: true,
        removeRight: true,
        child: builder(context),
      ),
      context: context,
    );
  }
}

Future<T?> kurumiShowAdaptiveBottomSheet<T>(
  BuildContext context, {
  required Widget Function(BuildContext context) builder,
  bool expand = false,
  double? height,
  Color? backgroundColor,
  RouteSettings? settings,
}) {
  return KurumiScreen.of(context).size != KurumiScreenSize.small
      ? showDialog<T>(
          context: context,
          routeSettings: settings,
          builder: (context) => Dialog(
            backgroundColor: backgroundColor,
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 28,
              vertical: 24,
            ),
            child: Container(
              constraints: const BoxConstraints(
                maxHeight: 400,
                maxWidth: 500,
              ),
              margin: const EdgeInsets.symmetric(
                horizontal: 4,
                vertical: 4,
              ),
              child: builder(context),
            ),
          ),
        )
      : kurumiShowAppModalBarBottomSheet<T>(
          context: context,
          settings: settings,
          barrierColor: kKurumiScrimColor,
          backgroundColor: backgroundColor ?? Colors.transparent,
          builder: (context) {
            var child = builder(context);
            // ignore: join_return_with_assignment
            child = !expand ? SizedBox(height: height, child: child) : child;
            return child;
          },
        );
}

Future<T?> kurumiShowAppModalBarBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  Color? backgroundColor,
  ShapeBorder? shape,
  Color barrierColor = kKurumiScrimColor,
  bool bounce = true,
  bool expand = false,
  Curve? animationCurve,
  bool useRootNavigator = false,
  bool isDismissible = true,
  Duration? duration,
  RouteSettings? settings,
}) => showBarModalBottomSheet<T>(
  context: context,
  settings: settings,
  barrierColor: barrierColor,
  duration: duration ?? Durations.medium2,
  backgroundColor: backgroundColor,
  shape: shape ?? KurumiShapes.sheet,
  bounce: bounce,
  expand: expand,
  animationCurve: animationCurve,
  useRootNavigator: useRootNavigator,
  isDismissible: isDismissible,
  builder: builder,
);

Future<T?> kurumiShowSideSheetFromLeft<T>({
  required Widget body,
  required BuildContext context,
  double? width,
  String barrierLabel = 'Side Sheet',
  bool barrierDismissible = true,
  Color barrierColor = kKurumiScrimColor,
  Duration transitionDuration = KurumiMotion.standard,
  RouteSettings? settings,
}) => _kurumiShowSheetSide<T>(
  body: body,
  width: width,
  rightSide: false,
  context: context,
  barrierLabel: barrierLabel,
  barrierDismissible: barrierDismissible,
  barrierColor: barrierColor,
  transitionDuration: transitionDuration,
  settings: settings,
);

Future<T?> kurumiShowSideSheetFromRight<T>({
  required Widget body,
  required BuildContext context,
  double? width,
  String barrierLabel = 'Side Sheet',
  bool barrierDismissible = true,
  Color barrierColor = kKurumiScrimColor,
  Duration transitionDuration = KurumiMotion.standard,
  RouteSettings? settings,
}) => _kurumiShowSheetSide<T>(
  body: body,
  width: width,
  rightSide: true,
  context: context,
  barrierLabel: barrierLabel,
  barrierDismissible: barrierDismissible,
  barrierColor: barrierColor,
  transitionDuration: transitionDuration,
  settings: settings,
);

Future<T?> _kurumiShowSheetSide<T>({
  required Widget body,
  required bool rightSide,
  required BuildContext context,
  required String barrierLabel,
  required bool barrierDismissible,
  required Color barrierColor,
  required Duration transitionDuration,
  double? width,
  RouteSettings? settings,
}) => showGeneralDialog(
  barrierLabel: barrierLabel,
  barrierDismissible: barrierDismissible,
  barrierColor: barrierColor,
  transitionDuration: transitionDuration,
  context: context,
  routeSettings: settings,
  pageBuilder: (context, animation1, animation2) {
    return Align(
      alignment: rightSide ? Alignment.centerRight : Alignment.centerLeft,
      // Floats as an inset card rather than a full-height panel.
      child: SafeArea(
        minimum: const EdgeInsets.all(KurumiSpacing.md),
        child: Material(
          color: Theme.of(context).colorScheme.surfaceContainer,
          elevation: 8,
          shadowColor: Colors.black.withValues(alpha: 0.4),
          clipBehavior: Clip.antiAlias,
          shape: KurumiShapes.xl,
          child: SizedBox(
            height: double.infinity,
            width: width ?? MediaQuery.widthOf(context) / 1.4,
            child: body,
          ),
        ),
      ),
    );
  },
  transitionBuilder: (context, animation1, animation2, child) {
    return SlideTransition(
      position:
          Tween(
            begin: Offset(rightSide ? 1.1 : -1.1, 0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation1,
              curve: KurumiMotion.emphasizedCurve,
              reverseCurve: KurumiMotion.exitCurve,
            ),
          ),
      child: child,
    );
  },
);
