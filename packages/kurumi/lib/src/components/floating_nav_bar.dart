import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import '../accessibility/behavior.dart';
import '../theme/motion.dart';
import '../theme/spacing.dart';
import '../theme/theme.dart';
import 'glass.dart';

class KurumiFloatingNavItem {
  const KurumiFloatingNavItem({
    required this.icon,
    required this.label,
    this.selectedIcon,
  });

  final Widget icon;
  final Widget? selectedIcon;
  final String label;
}

/// Floating glass pill used as the primary navigation bar.
///
/// It sizes itself to its items and adds the bottom safe area below it, so it
/// can be dropped straight into `Scaffold.bottomNavigationBar` together with
/// `extendBody: true` to let content scroll underneath.
class KurumiFloatingNavBar extends StatelessWidget {
  const KurumiFloatingNavBar({
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
    super.key,
    this.header,
  });

  final List<KurumiFloatingNavItem> items;

  /// Null when the current destination isn't one of [items].
  final int? selectedIndex;
  final ValueChanged<int> onSelected;

  /// Optional content stacked above the pill, such as a secondary switcher.
  final Widget? header;

  static const double itemWidth = 76;
  static const double itemHeight = 52;
  static const double _padding = 4;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: KurumiSpacing.floatingInset,
        right: KurumiSpacing.floatingInset,
        bottom: math.max(bottomInset, KurumiSpacing.md),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (header case final header?) ...[
            header,
            const SizedBox(height: KurumiSpacing.sm),
          ],
          KurumiGlass(
            elevated: true,
            child: Padding(
              padding: const EdgeInsets.all(_padding),
              child: _Items(
                items: items,
                selectedIndex: selectedIndex,
                onSelected: onSelected,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Items extends StatelessWidget {
  const _Items({
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<KurumiFloatingNavItem> items;
  final int? selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final behavior =
        KurumiTheme.maybeBehaviorOf(context) ?? const KurumiBehaviorData();
    final maxWidth =
        MediaQuery.sizeOf(context).width -
        KurumiSpacing.floatingInset * 2 -
        KurumiFloatingNavBar._padding * 2;
    final itemWidth = math.min(
      KurumiFloatingNavBar.itemWidth,
      maxWidth / items.length,
    );

    return SizedBox(
      width: itemWidth * items.length,
      height: KurumiFloatingNavBar.itemHeight,
      child: Stack(
        children: [
          if (selectedIndex case final index?)
            AnimatedPositioned(
              duration: behavior.effectiveDuration(KurumiMotion.standard),
              curve: KurumiMotion.emphasizedCurve,
              left: index * itemWidth,
              top: 0,
              bottom: 0,
              width: itemWidth,
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  shape: const StadiumBorder(),
                  color: colorScheme.primary.withValues(alpha: 0.14),
                ),
              ),
            ),
          Row(
            children: [
              for (final (index, item) in items.indexed)
                SizedBox(
                  width: itemWidth,
                  child: _NavButton(
                    item: item,
                    selected: index == selectedIndex,
                    onTap: () {
                      behavior.provideSelectionFeedback();
                      onSelected(index);
                    },
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatefulWidget {
  const _NavButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final KurumiFloatingNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> {
  var _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final behavior =
        KurumiTheme.maybeBehaviorOf(context) ?? const KurumiBehaviorData();
    final color = widget.selected
        ? colorScheme.primary
        : colorScheme.onSurface.withValues(alpha: 0.75);

    return Semantics(
      button: true,
      selected: widget.selected,
      label: widget.item.label,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _pressed ? 0.9 : 1,
          duration: behavior.effectiveDuration(KurumiMotion.fast),
          curve: KurumiMotion.standardCurve,
          child: IconTheme.merge(
            data: IconThemeData(
              color: color,
              size: 24,
              fill: widget.selected ? 1 : 0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.selected)
                  widget.item.selectedIcon ?? widget.item.icon
                else
                  widget.item.icon,
                const SizedBox(height: 2),
                Text(
                  widget.item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
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
