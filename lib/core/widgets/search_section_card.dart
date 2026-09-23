// Package imports:
import 'package:kurumi/kurumi.dart';
import 'package:kurumi/material.dart';

/// A search landing section: a small uppercase header with optional
/// actions, above a rounded card holding the content.
class SearchSectionCard extends StatelessWidget {
  const SearchSectionCard({
    required this.child,
    super.key,
    this.title,
    this.actions = const [],
    this.trailing,
    this.padding = const EdgeInsets.all(KurumiSpacing.md),
  });

  final String? title;

  /// Small buttons shown right after the title, like edit or settings.
  final List<Widget> actions;
  final Widget? trailing;
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = Kurumi.themeOf(context);
    final title = this.title;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: KurumiSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null || trailing != null)
            Padding(
              padding: const EdgeInsets.only(
                left: KurumiSpacing.xs,
                bottom: KurumiSpacing.sm,
              ),
              child: SizedBox(
                height: 32,
                child: Row(
                  children: [
                    if (title != null)
                      Text(
                        title.toUpperCase(),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.4,
                        ),
                      ),
                    for (final action in actions) ...[
                      const SizedBox(width: KurumiSpacing.sm),
                      action,
                    ],
                    const Spacer(),
                    ?trailing,
                  ],
                ),
              ),
            ),
          DecoratedBox(
            decoration: ShapeDecoration(
              shape: KurumiShapes.lg,
              color: theme.colorScheme.surfaceContainer,
            ),
            child: Padding(
              padding: padding,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

/// Small round button for section header actions.
class SearchSectionActionButton extends StatelessWidget {
  const SearchSectionActionButton({
    required this.icon,
    required this.onPressed,
    super.key,
    this.selected = false,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final bool selected;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Kurumi.themeOf(context).colorScheme;

    return SizedBox.square(
      dimension: 28,
      child: IconButton(
        tooltip: tooltip,
        padding: EdgeInsets.zero,
        style: IconButton.styleFrom(
          backgroundColor: selected
              ? colorScheme.primary
              : colorScheme.onSurface.withValues(alpha: 0.08),
        ),
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 16,
          fill: 1,
          color: selected
              ? colorScheme.onPrimary
              : colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

/// Wraps pills with comfortable spacing.
class SearchPillWrap extends StatelessWidget {
  const SearchPillWrap({
    required this.children,
    super.key,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: KurumiSpacing.sm,
      runSpacing: KurumiSpacing.sm,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: children,
    );
  }
}
