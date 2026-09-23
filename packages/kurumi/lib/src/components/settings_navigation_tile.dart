import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

import '../theme/shapes.dart';
import '../theme/spacing.dart';

/// Row that opens a settings page. Meant to sit inside a
/// `KurumiSettingsSection`, with its icon on a small tinted badge.
class KurumiSettingsEntryTile extends StatelessWidget {
  const KurumiSettingsEntryTile({
    required this.title,
    required this.leading,
    super.key,
    this.onTap,
    this.showLeading = true,
    this.subtitle,
    this.selected = false,
    this.dense = false,
  });

  final bool showLeading;
  final String title;
  final VoidCallback? onTap;
  final Widget leading;
  final String? subtitle;
  final bool selected;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final foreground = selected ? colorScheme.onPrimaryContainer : null;

    return Semantics(
      button: true,
      enabled: onTap != null,
      selected: selected,
      onTap: onTap,
      child: Material(
        color: selected ? colorScheme.primaryContainer : Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: dense ? 40 : 48),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: KurumiSpacing.md,
                vertical: subtitle != null
                    ? KurumiSpacing.sm
                    : KurumiSpacing.xs,
              ),
              child: Row(
                children: [
                  if (showLeading) ...[
                    _IconBadge(child: leading),
                    const SizedBox(width: KurumiSpacing.md),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: foreground,
                          ),
                        ),
                        if (subtitle case final subtitle?)
                          Text(
                            subtitle,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (onTap != null && !dense)
                    Icon(
                      Symbols.chevron_right,
                      size: 20,
                      color: colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.6,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: ShapeDecoration(
        shape: KurumiShapes.radius(KurumiRadius.xs + 2),
        color: colorScheme.primary.withValues(alpha: 0.15),
      ),
      child: SizedBox.square(
        dimension: 30,
        child: Center(
          child: IconTheme.merge(
            data: IconThemeData(
              size: 18,
              color: colorScheme.primary,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
