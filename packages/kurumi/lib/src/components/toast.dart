import 'package:material_ui/material_ui.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:oktoast/oktoast.dart';

import '../theme/motion.dart';
import '../theme/spacing.dart';
import '../theme/theme.dart';
import 'glass.dart';

void kurumiShowSuccessToast(
  BuildContext context,
  String message, {
  Duration? duration,
  Color? backgroundColor,
  TextStyle? textStyle,
  IconData? icon,
}) => _showHud(
  context,
  message,
  icon: icon ?? Symbols.check_circle,
  iconColor: Theme.of(context).colorScheme.primary,
  duration: duration,
  backgroundColor: backgroundColor,
  textStyle: textStyle,
);

void kurumiShowErrorToast(
  BuildContext context,
  String message, {
  Duration? duration,
}) {
  KurumiTheme.maybeBehaviorOf(context)?.provideErrorFeedback();
  _showHud(
    context,
    message,
    icon: Symbols.error,
    iconColor: Theme.of(context).colorScheme.error,
    duration: duration ?? const Duration(seconds: 4),
  );
}

/// Shows a compact glass banner under the status bar. Toasts live above the
/// app's navigator, so the caller's theme is captured and re-applied here.
void _showHud(
  BuildContext context,
  String message, {
  required IconData icon,
  required Color iconColor,
  Duration? duration,
  Color? backgroundColor,
  TextStyle? textStyle,
}) {
  final theme = Theme.of(context);
  final mediaQuery = MediaQuery.maybeOf(context);
  final topInset = mediaQuery?.padding.top ?? 0;
  final reduceMotion = KurumiTheme.maybeBehaviorOf(context)?.reduceMotion;

  showToastWidget(
    Theme(
      data: theme,
      child: _KurumiHud(
        message: message,
        icon: icon,
        iconColor: iconColor,
        backgroundColor: backgroundColor,
        textStyle: textStyle,
      ),
    ),
    context: context,
    duration: duration,
    dismissOtherToast: true,
    position: ToastPosition(
      align: Alignment.topCenter,
      offset: topInset + KurumiSpacing.sm,
    ),
    animationDuration: reduceMotion ?? false
        ? Duration.zero
        : KurumiMotion.emphasized,
    animationCurve: Curves.linear,
    animationBuilder: (context, child, controller, percent) {
      final curved = CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutBack,
        reverseCurve: KurumiMotion.exitCurve,
      );

      return FadeTransition(
        opacity: controller,
        child: SlideTransition(
          position: Tween(
            begin: const Offset(0, -0.6),
            end: Offset.zero,
          ).animate(curved),
          child: ScaleTransition(
            scale: Tween(begin: 0.9, end: 1.0).animate(curved),
            child: child,
          ),
        ),
      );
    },
  );
}

class _KurumiHud extends StatelessWidget {
  const _KurumiHud({
    required this.message,
    required this.icon,
    required this.iconColor,
    this.backgroundColor,
    this.textStyle,
  });

  final String message;
  final IconData icon;
  final Color iconColor;
  final Color? backgroundColor;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: KurumiSpacing.floatingInset,
        ),
        child: KurumiGlass(
          elevated: true,
          thickness: KurumiGlassThickness.thick,
          tint: backgroundColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: KurumiSpacing.lg,
              vertical: KurumiSpacing.md,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, fill: 1, size: 20, color: iconColor),
                const SizedBox(width: KurumiSpacing.sm),
                Flexible(
                  child: Text(
                    message,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style:
                        textStyle ??
                        theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void kurumiShowSimpleSnackBar({
  required BuildContext context,
  required Widget content,
  Duration? duration,
  SnackBarBehavior? behavior,
  SnackBarAction? action,
}) {
  final snackBarBehavior = behavior ?? SnackBarBehavior.floating;
  final snackbar = SnackBar(
    action: action,
    persist: false,
    behavior: snackBarBehavior,
    duration: duration ?? const Duration(seconds: 4),
    elevation: 6,
    width: _calculateSnackBarWidth(context, snackBarBehavior),
    content: content,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}

double? _calculateSnackBarWidth(
  BuildContext context,
  SnackBarBehavior behavior,
) {
  if (behavior == SnackBarBehavior.fixed) return null;
  final width = MediaQuery.maybeWidthOf(context) ?? 400;

  return width > 400 ? 400 : width;
}
