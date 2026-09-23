// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kurumi/kurumi.dart';
import 'package:kurumi/material.dart';

// Project imports:
import '../../../../../../core/tags/tag/types.dart';
import '../../../../../../core/widgets/search_section_card.dart';
import '../../../../tags/tag/widgets.dart';

class TrendingTags extends ConsumerWidget {
  const TrendingTags({
    required this.onTagTap,
    required this.tags,
    required this.colorBuilder,
    super.key,
  });

  final ValueChanged<String>? onTagTap;
  final List<Tag>? tags;
  final Color? Function(BuildContext context, String name)? colorBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (tags) {
      final tags? when tags.isNotEmpty => SearchPillWrap(
        children: [
          for (final tag in tags)
            DanbooruTagContextMenu(
              tag: tag.name,
              child: KurumiPill(
                label: tag.displayName,
                color: colorBuilder?.call(context, tag.category.name),
                onTap: () => onTagTap?.call(tag.name),
              ),
            ),
        ],
      ),
      _ => const SizedBox.shrink(),
    };
  }
}

/// Pill-shaped skeletons sized like the tags they stand in for.
class TrendingTagsPlaceholder extends StatelessWidget {
  const TrendingTagsPlaceholder({
    required this.tags,
    super.key,
  });

  final List<Tag> tags;

  @override
  Widget build(BuildContext context) {
    return SearchPillWrap(
      children: [
        for (final tag in tags)
          ExcludeSemantics(
            child: DecoratedBox(
              decoration: ShapeDecoration(
                shape: const StadiumBorder(),
                color: Kurumi.themeOf(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.06),
              ),
              child: Opacity(
                opacity: 0,
                child: KurumiPill(label: tag.name),
              ),
            ),
          ),
      ],
    );
  }
}
