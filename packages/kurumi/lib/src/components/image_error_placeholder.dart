import 'package:material_ui/material_ui.dart';
import '../theme/shapes.dart';

class KurumiImageErrorPlaceholder extends StatelessWidget {
  const KurumiImageErrorPlaceholder({
    required this.child,
    super.key,
    this.borderRadius,
  });

  final Widget child;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: borderRadius ?? KurumiBorderRadius.sm,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) => Container(
          margin: EdgeInsets.symmetric(
            horizontal: constraints.maxWidth * 0.25,
            vertical: constraints.maxHeight * 0.25,
          ),
          child: child,
        ),
      ),
    );
  }
}
