// Dart imports:
import 'dart:ui';

// Package imports:
import 'package:kurumi/kurumi.dart';
import 'package:kurumi/material.dart';

// Project imports:
import '../../../../configs/config/types.dart';
import '../../../post/types.dart';
import '../pages/quick_preview_image_dialog.dart';

void goToImagePreviewPage(
  BuildContext context,
  Post post,
  BooruConfigAuth config,
) {
  final duration = context.kurumiBehavior.effectiveDuration(
    KurumiMotion.standard,
  );

  showGeneralDialog(
    context: context,
    barrierColor: Colors.transparent,
    transitionDuration: duration,
    pageBuilder: (context, animation, secondaryAnimation) =>
        QuickPreviewImageDialog(
          post: post,
          config: config,
        ),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutBack,
        reverseCurve: KurumiMotion.exitCurve,
      );

      return AnimatedBuilder(
        animation: animation,
        builder: (context, child) => BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 16 * animation.value,
            sigmaY: 16 * animation.value,
          ),
          child: ColoredBox(
            color: kKurumiScrimColor.withValues(
              alpha: kKurumiScrimColor.a * animation.value,
            ),
            child: child,
          ),
        ),
        child: FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.9, end: 1).animate(curved),
            child: child,
          ),
        ),
      );
    },
  );
}
