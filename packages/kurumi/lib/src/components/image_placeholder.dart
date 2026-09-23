import 'package:material_ui/material_ui.dart';

import '../theme/shapes.dart';
import '../theme/theme.dart';

/// Skeleton box shown while an image loads. It gently pulses unless reduced
/// motion is on.
class KurumiImagePlaceholder extends StatefulWidget {
  const KurumiImagePlaceholder({
    super.key,
    this.borderRadius,
    this.width,
    this.height,
  });

  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final double? height;

  @override
  State<KurumiImagePlaceholder> createState() => _KurumiImagePlaceholderState();
}

class _KurumiImagePlaceholderState extends State<KurumiImagePlaceholder>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  );

  late final _pulse = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOutSine,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final reduceMotion =
        KurumiTheme.maybeBehaviorOf(context)?.reduceMotion ?? false;

    if (reduceMotion) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.surfaceContainerHigh;
    final borderRadius = widget.borderRadius ?? KurumiBorderRadius.sm;

    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, _) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.4 + 0.3 * _pulse.value),
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}
