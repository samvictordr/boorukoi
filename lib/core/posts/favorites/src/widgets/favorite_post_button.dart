// Dart imports:
import 'dart:async';

// Package imports:
import 'package:i18n/i18n.dart';
import 'package:kurumi/kurumi.dart';
import 'package:kurumi/material.dart';
import 'package:material_symbols_icons/symbols.dart';

// Project imports:
import '../../../../themes/theme/types.dart';

class FavoritePostButton extends StatelessWidget {
  const FavoritePostButton({
    required this.isFaved,
    required this.isAuthorized,
    required this.addFavorite,
    required this.removeFavorite,
    super.key,
  });

  final bool? isFaved;
  final bool isAuthorized;
  final Future<void> Function() addFavorite;
  final Future<void> Function() removeFavorite;

  @override
  Widget build(BuildContext context) {
    return KurumiTooltip(
      message: context.t.post.action.favorite,
      child: IconButton(
        splashRadius: 16,
        onPressed: isFaved != null
            ? () {
                if (!isAuthorized) {
                  Kurumi.showSimpleSnackBar(
                    context: context,
                    content: Text(
                      context.t.post.detail.login_required_notice,
                    ),
                    duration: KurumiDurations.shortToast,
                  );

                  return;
                }
                context.kurumiBehavior.provideSelectionFeedback();

                if (isFaved!) {
                  unawaited(removeFavorite());
                } else {
                  unawaited(addFavorite());
                }
              }
            : null,
        icon: AnimatedSwitcher(
          duration: context.kurumiBehavior.effectiveDuration(
            KurumiMotion.emphasized,
          ),
          switchInCurve: Curves.easeOutBack,
          switchOutCurve: KurumiMotion.exitCurve,
          transitionBuilder: (child, animation) => ScaleTransition(
            scale: animation,
            child: child,
          ),
          child: (isFaved ?? false)
              ? Icon(
                  Symbols.favorite,
                  key: const ValueKey(true),
                  fill: 1,
                  color: context.colors.upvoteColor,
                  size: 20,
                )
              : const Icon(
                  Symbols.favorite,
                  key: ValueKey(false),
                  size: 20,
                ),
        ),
      ),
    );
  }
}
