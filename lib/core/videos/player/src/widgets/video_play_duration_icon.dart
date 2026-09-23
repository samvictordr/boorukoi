// Package imports:
import 'package:foundation/foundation.dart';
import 'package:kurumi/kurumi.dart';
import 'package:kurumi/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class VideoPlayDurationIcon extends StatelessWidget {
  const VideoPlayDurationIcon({
    required this.duration,
    required this.hasSound,
    super.key,
  });

  final double duration;
  final bool? hasSound;

  @override
  Widget build(BuildContext context) {
    final durationLabel = formatDurationForMedia(
      Duration(
        seconds: duration < 1 ? 1 : duration.round(),
      ),
    );
    final colors = Kurumi.semanticColorsOf(context);
    final background = colors.overlayDim;
    final foreground = colors.onOverlayDim;

    return Semantics(
      label: durationLabel,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        height: 24,
        decoration: BoxDecoration(
          color: background,
          borderRadius: const BorderRadius.all(
            Radius.circular(KurumiRadius.xs),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              durationLabel,
              style: TextStyle(
                color: foreground,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.25,
              ),
            ),
            if (hasSound case final sound?)
              Padding(
                padding: const EdgeInsets.only(left: 1),
                child: Icon(
                  sound
                      ? Symbols.volume_up_rounded
                      : Symbols.volume_off_rounded,
                  color: foreground,
                  size: 18,
                  fill: 1,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
