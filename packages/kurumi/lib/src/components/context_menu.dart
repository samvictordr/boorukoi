import 'dart:ui' as ui;

import 'package:anchor_ui/anchor_ui.dart';
import 'package:flutter/rendering.dart';
import 'package:material_ui/material_ui.dart';

import '../accessibility/behavior.dart';
import '../foundation/platform.dart';
import '../theme/theme.dart';
import '../theme/motion.dart';
import '../theme/shapes.dart';
import '../theme/spacing.dart';
import 'glass.dart';

typedef _Snapshot = ({ui.Image image, Rect rect});

class KurumiContextMenu extends StatefulWidget {
  const KurumiContextMenu({
    required this.child,
    required this.menuItemsBuilder,
    super.key,
  });

  final Widget child;
  final List<Widget> Function(BuildContext context) menuItemsBuilder;

  @override
  State<KurumiContextMenu> createState() => _KurumiContextMenuState();
}

class _KurumiContextMenuState extends State<KurumiContextMenu> {
  final _childKey = GlobalKey();
  _Snapshot? _snapshot;

  /// Captures the pressed item so it can be shown lifted above the blurred
  /// backdrop. An image is used instead of rebuilding the child because the
  /// menu overlay lives outside the child's inherited widgets.
  void _captureSnapshot() {
    _disposeSnapshot();

    if (_childKey.currentContext?.findRenderObject()
        case final RenderRepaintBoundary boundary when boundary.hasSize) {
      final origin = boundary.localToGlobal(Offset.zero);
      final pixelRatio = MediaQuery.devicePixelRatioOf(context);

      try {
        _snapshot = (
          image: boundary.toImageSync(pixelRatio: pixelRatio),
          rect: origin & boundary.size,
        );
      } catch (_) {
        _snapshot = null;
      }
    }
  }

  void _disposeSnapshot() {
    _snapshot?.image.dispose();
    _snapshot = null;
  }

  @override
  void dispose() {
    _disposeSnapshot();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final behavior =
        KurumiTheme.maybeBehaviorOf(context) ?? const KurumiBehaviorData();
    final isMobile = kurumiIsMobilePlatform();

    return AnchorContextMenu(
      viewPadding: const EdgeInsets.all(8),
      backdropBuilder: isMobile
          ? (context) => _LiftedBackdrop(
              snapshot: _snapshot,
              reduceMotion: behavior.reduceMotion,
            )
          : (context) => const ColoredBox(color: Colors.transparent),
      onShow: behavior.contextMenuShowFeedback,
      onDismiss: _disposeSnapshot,
      menuBuilder: (context) => _MenuSurface(
        reduceMotion: behavior.reduceMotion,
        children: widget.menuItemsBuilder(context),
      ),
      childBuilder: (context) => KurumiAdaptiveContextMenuGestureTrigger(
        onBeforeShow: isMobile ? _captureSnapshot : null,
        child: RepaintBoundary(
          key: _childKey,
          child: widget.child,
        ),
      ),
    );
  }
}

class _MenuSurface extends StatelessWidget {
  const _MenuSurface({
    required this.children,
    required this.reduceMotion,
  });

  final List<Widget> children;
  final bool reduceMotion;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: reduceMotion ? 1 : 0, end: 1),
      duration: KurumiMotion.standard,
      curve: Curves.easeOutBack,
      builder: (context, t, child) => Opacity(
        opacity: t.clamp(0.0, 1.0),
        child: Transform.scale(
          scale: 0.85 + 0.15 * t,
          alignment: Alignment.topLeft,
          child: child,
        ),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 240),
        child: KurumiGlass(
          shape: KurumiShapes.md,
          thickness: KurumiGlassThickness.thick,
          elevated: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: KurumiSpacing.xs,
              horizontal: KurumiSpacing.xs,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}

class _LiftedBackdrop extends StatelessWidget {
  const _LiftedBackdrop({
    required this.snapshot,
    required this.reduceMotion,
  });

  final _Snapshot? snapshot;
  final bool reduceMotion;

  @override
  Widget build(BuildContext context) {
    final snapshot = this.snapshot;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: reduceMotion ? 1 : 0, end: 1),
      duration: KurumiMotion.standard,
      curve: KurumiMotion.standardCurve,
      builder: (context, t, _) => Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 12 * t, sigmaY: 12 * t),
              child: ColoredBox(
                color: Colors.black.withValues(alpha: 0.25 * t),
              ),
            ),
          ),
          if (snapshot != null)
            Positioned.fromRect(
              rect: snapshot.rect,
              child: IgnorePointer(
                child: Transform.scale(
                  scale: 1 + 0.04 * Curves.easeOutBack.transform(t),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: KurumiBorderRadius.sm,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3 * t),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: RawImage(
                      image: snapshot.image,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class KurumiContextMenuDivider extends StatelessWidget {
  const KurumiContextMenuDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      endIndent: 12,
      indent: 12,
      height: 8,
    );
  }
}

class KurumiAdaptiveContextMenuGestureTrigger extends StatelessWidget {
  const KurumiAdaptiveContextMenuGestureTrigger({
    required this.child,
    super.key,
    this.onBeforeShow,
  });

  final Widget child;

  /// Runs right before the menu opens from a long press.
  final VoidCallback? onBeforeShow;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: kurumiIsMobilePlatform()
          ? (details) {
              onBeforeShow?.call();
              context.showMenu(details.globalPosition);
            }
          : null,
      onSecondaryTapDown: !kurumiIsMobilePlatform()
          ? (details) {
              context.showMenu(details.globalPosition);
            }
          : null,
      child: child,
    );
  }
}

class KurumiContextMenuTile extends StatelessWidget {
  const KurumiContextMenuTile({
    required this.title,
    super.key,
    this.onTap,
    this.enabled = true,
    this.hideOnTap = true,
  });

  final String title;
  final VoidCallback? onTap;
  final bool enabled;
  final bool hideOnTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final behavior =
        KurumiTheme.maybeBehaviorOf(context) ?? const KurumiBehaviorData();

    void handleTap() {
      if (hideOnTap) {
        context.hideMenu();
      }

      behavior.contextMenuSelectionFeedback?.call();
      onTap?.call();
    }

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
        ),
        constraints: const BoxConstraints(
          minWidth: 200,
        ),
        child: Semantics(
          button: true,
          enabled: enabled,
          label: title,
          onTap: enabled ? handleTap : null,
          excludeSemantics: true,
          child: InkWell(
            hoverColor: enabled
                ? colorScheme.onSurface.withValues(alpha: 0.08)
                : Colors.transparent,
            customBorder: RoundedRectangleBorder(
              borderRadius: KurumiBorderRadius.sm,
            ),
            onTap: enabled ? handleTap : null,
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 12,
              ),
              child: Text(
                title,
                style: TextStyle(
                  color: enabled
                      ? colorScheme.onSurface
                      : colorScheme.onSurface.withValues(alpha: 0.38),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
