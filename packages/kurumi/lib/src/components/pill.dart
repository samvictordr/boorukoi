import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

import '../theme/motion.dart';
import '../theme/spacing.dart';
import '../theme/theme.dart';

enum KurumiPillTone {
  /// Tinted with the accent color, for suggestions the user can act on.
  accent,

  /// Neutral fill, for the user's own saved content.
  neutral,
}

/// Soft, tinted capsule for tags and quick filters. Shrinks slightly while
/// pressed and can show a delete affordance.
class KurumiPill extends StatefulWidget {
  const KurumiPill({
    required this.label,
    super.key,
    this.icon,
    this.onTap,
    this.onDelete,
    this.tone = KurumiPillTone.neutral,
    this.color,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onTap;

  /// Shows a trailing delete button when set.
  final VoidCallback? onDelete;
  final KurumiPillTone tone;

  /// Overrides the tone color, e.g. with a tag category color.
  final Color? color;

  @override
  State<KurumiPill> createState() => _KurumiPillState();
}

class _KurumiPillState extends State<KurumiPill> {
  var _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final behavior = KurumiTheme.maybeBehaviorOf(context);
    final accent = widget.color ?? colorScheme.primary;

    final (background, foreground) = switch ((widget.tone, widget.color)) {
      (KurumiPillTone.accent, _) || (_, Color()) => (
        accent.withValues(alpha: 0.16),
        accent,
      ),
      (KurumiPillTone.neutral, null) => (
        colorScheme.onSurface.withValues(alpha: 0.08),
        colorScheme.onSurface,
      ),
    };

    final interactive = widget.onTap != null;

    return Semantics(
      button: interactive,
      label: widget.label,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: interactive ? (_) => _setPressed(true) : null,
        onTapUp: interactive ? (_) => _setPressed(false) : null,
        onTapCancel: interactive ? () => _setPressed(false) : null,
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _pressed ? 0.94 : 1,
          duration:
              behavior?.effectiveDuration(KurumiMotion.fast) ??
              KurumiMotion.fast,
          curve: KurumiMotion.standardCurve,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              shape: const StadiumBorder(),
              color: _pressed
                  ? Color.alphaBlend(
                      foreground.withValues(alpha: 0.08),
                      background,
                    )
                  : background,
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: widget.icon != null ? KurumiSpacing.sm : KurumiSpacing.md,
                right: widget.onDelete != null
                    ? KurumiSpacing.xs
                    : KurumiSpacing.md,
                top: 7,
                bottom: 7,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.icon case final icon?) ...[
                    Icon(icon, size: 16, color: foreground),
                    const SizedBox(width: KurumiSpacing.xs),
                  ],
                  Flexible(
                    child: Text(
                      widget.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: foreground,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (widget.onDelete case final onDelete?) ...[
                    const SizedBox(width: KurumiSpacing.xxs),
                    GestureDetector(
                      onTap: onDelete,
                      child: Icon(
                        Symbols.cancel,
                        fill: 1,
                        size: 18,
                        color: foreground.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
