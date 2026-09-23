import 'package:material_ui/material_ui.dart';

import '../theme/shapes.dart';
import '../theme/spacing.dart';

/// Inset grouped list section: an optional header, rows on a rounded card
/// separated by hairlines, and an optional footer for explanatory text.
///
/// Rows with a leading badge (`KurumiSettingsEntryTile`) should use
/// [entryTileSeparatorIndent].
class KurumiSettingsSection extends StatelessWidget {
  const KurumiSettingsSection({
    required this.children,
    super.key,
    this.header,
    this.footer,
    this.padding = const EdgeInsets.only(bottom: KurumiSpacing.xxl),
    this.separatorIndent = KurumiSpacing.lg,
  });

  final String? header;
  final String? footer;
  final List<Widget> children;
  final EdgeInsetsGeometry padding;

  /// Where row separators start, usually aligned with the row text.
  final double separatorIndent;

  /// Badge inset + badge + gap in `KurumiSettingsEntryTile`.
  static const entryTileSeparatorIndent =
      KurumiSpacing.md + 30 + KurumiSpacing.md;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (header case final header?)
            KurumiSettingsSectionHeader(label: header),
          ClipRSuperellipse(
            borderRadius: KurumiBorderRadius.md,
            child: Material(
              color: colorScheme.surfaceContainer,
              child: ListTileTheme.merge(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: KurumiSpacing.lg,
                ),
                shape: const RoundedRectangleBorder(),
                minTileHeight: 48,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final (index, child) in children.indexed) ...[
                      if (index > 0)
                        Divider(
                          height: 0.5,
                          thickness: 0.5,
                          indent: separatorIndent,
                          color: colorScheme.outlineVariant.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      child,
                    ],
                  ],
                ),
              ),
            ),
          ),
          if (footer case final footer?)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                KurumiSpacing.lg,
                KurumiSpacing.sm,
                KurumiSpacing.lg,
                0,
              ),
              child: Text(
                footer,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class KurumiSettingsSectionHeader extends StatelessWidget {
  const KurumiSettingsSectionHeader({
    required this.label,
    super.key,
    this.trailing,
  });

  final String label;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        KurumiSpacing.lg,
        0,
        KurumiSpacing.lg,
        KurumiSpacing.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label.toUpperCase(),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.2,
              ),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
