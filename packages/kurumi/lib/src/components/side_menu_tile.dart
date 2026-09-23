import 'package:material_ui/material_ui.dart';

import '../theme/shapes.dart';
import '../theme/spacing.dart';

class KurumiSideMenuTile extends StatelessWidget {
  const KurumiSideMenuTile({
    required this.icon,
    required this.title,
    required this.onTap,
    super.key,
  });

  final Widget icon;
  final Widget title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      button: true,
      onTap: onTap,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          customBorder: KurumiShapes.sm,
          child: DefaultTextStyle(
            style:
                theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ) ??
                const TextStyle(),
            child: IconTheme.merge(
              data: IconThemeData(
                size: 22,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: KurumiSpacing.md,
                  vertical: 11,
                ),
                child: Row(
                  children: [
                    icon,
                    const SizedBox(width: KurumiSpacing.md),
                    Expanded(child: title),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
