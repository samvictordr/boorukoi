// Package imports:
import 'package:anchor_ui/anchor_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kurumi/kurumi.dart';
import 'package:kurumi/material.dart';

// Project imports:
import '../types/danbooru_upload_post.dart';

class DanbooruUploadPostContextMenu extends ConsumerWidget {
  const DanbooruUploadPostContextMenu({
    super.key,
    required this.child,
    required this.post,
    required this.onVisibilityChanged,
  });

  final Widget child;
  final DanbooruUploadPost post;
  final void Function(bool visible) onVisibilityChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnchorContextMenu(
      menuBuilder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Kurumi.themeOf(context).colorScheme.surfaceContainer,
            borderRadius: KurumiBorderRadius.sm,
            boxShadow: kElevationToShadow[4],
          ),
          constraints: const BoxConstraints(
            maxWidth: 220,
          ),
          child: ListView(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 4,
            ),
            shrinkWrap: true,
            children: [
              KurumiContextMenuTile(
                title: 'Hide upload',
                onTap: () {
                  context.hideMenu();
                  onVisibilityChanged(false);
                },
              ),
            ],
          ),
        );
      },
      childBuilder: (context) => KurumiAdaptiveContextMenuGestureTrigger(
        child: child,
      ),
    );
  }
}
