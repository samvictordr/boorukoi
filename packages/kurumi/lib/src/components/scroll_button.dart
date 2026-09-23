import 'package:material_ui/material_ui.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../accessibility/behavior.dart';
import '../theme/motion.dart';
import '../theme/theme.dart';
import 'glass.dart';

class KurumiScrollToTopButton extends StatelessWidget {
  const KurumiScrollToTopButton({
    super.key,
    this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return _GlassFab(
      onPressed: onPressed,
      icon: Symbols.keyboard_arrow_up,
    );
  }
}

class KurumiScrollToBottomButton extends StatelessWidget {
  const KurumiScrollToBottomButton({
    super.key,
    this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return _GlassFab(
      onPressed: onPressed,
      icon: Symbols.keyboard_arrow_down,
    );
  }
}

class _GlassFab extends StatelessWidget {
  const _GlassFab({
    required this.onPressed,
    required this.icon,
  });

  final VoidCallback? onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return KurumiGlass(
      shape: const CircleBorder(),
      elevated: true,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}

extension KurumiScrollToTopX on ScrollController {
  /// Animates back to the top. From far down the list it first jumps closer
  /// so the animation stays short and doesn't have to build every item.
  Future<void> animateToTop(BuildContext context) async {
    if (!hasClients) return;

    final behavior =
        KurumiTheme.maybeBehaviorOf(context) ?? const KurumiBehaviorData();

    if (behavior.reduceMotion) {
      jumpTo(0);
      return;
    }

    final viewport = position.viewportDimension;
    if (offset > viewport * 6) {
      jumpTo(viewport * 2);
    }

    await animateTo(
      0,
      duration: KurumiMotion.emphasized,
      curve: KurumiMotion.emphasizedCurve,
    );
  }
}
