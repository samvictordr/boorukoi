// Package imports:
import 'package:kurumi/kurumi.dart';
import 'package:kurumi/material.dart';

class SheetDragline extends StatelessWidget {
  const SheetDragline({
    super.key,
    this.maxWidth = 48,
    this.minWidth = 36,
    this.height = 5,
    this.isHolding = false,
    this.padding,
  });

  final double maxWidth;
  final double minWidth;
  final double height;
  final bool isHolding;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Kurumi.themeOf(context).colorScheme;

    return GestureDetector(
      child: ColoredBox(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding:
                  padding ??
                  const EdgeInsets.only(
                    top: 6,
                    bottom: 28,
                  ),
              color: Colors.transparent,
              child: AnimatedContainer(
                duration: KurumiMotion.standard,
                curve: KurumiMotion.standardCurve,
                width: isHolding ? maxWidth : minWidth,
                height: height,
                decoration: ShapeDecoration(
                  shape: const StadiumBorder(),
                  color: colorScheme.onSurface.withValues(
                    alpha: isHolding ? 0.5 : 0.3,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
