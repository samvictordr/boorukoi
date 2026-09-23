// Package imports:
import 'package:kurumi/kurumi.dart';
import 'package:kurumi/material.dart';

class ImageOverlayIcon extends StatelessWidget {
  const ImageOverlayIcon({
    required this.icon,
    super.key,
    this.size,
  });

  final IconData icon;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final colors = Kurumi.semanticColorsOf(context);

    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: colors.overlayDim,
        borderRadius: const BorderRadius.all(Radius.circular(KurumiRadius.xs)),
      ),
      child: Icon(
        icon,
        color: colors.onOverlayDim,
        size: size ?? 18,
        weight: 700,
      ),
    );
  }
}
