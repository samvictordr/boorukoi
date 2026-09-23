// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i18n/i18n.dart';
import 'package:kurumi/material.dart';

// Project imports:
import '../../../../../../core/configs/config/providers.dart';
import '../../../../../../core/tags/tag/providers.dart';
import '../../../../../../core/widgets/search_section_card.dart';
import '../local_providers.dart';
import 'trending_tags.dart';

class TrendingSection extends ConsumerWidget {
  const TrendingSection({
    required this.onTagTap,
    super.key,
  });

  final ValueChanged<String>? onTagTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watchConfigFilter;

    return switch (ref.watch(top15TrendingTagsProvider(config))) {
      AsyncData(value: final tags) when tags.isNotEmpty => SearchSectionCard(
        title: context.t.search.trending,
        child: TrendingTags(
          onTagTap: onTagTap,
          colorBuilder: (context, name) =>
              ref.watch(tagColorProvider((config.auth, name))),
          tags: tags,
        ),
      ),
      AsyncLoading() => SearchSectionCard(
        title: context.t.search.trending,
        child: TrendingTagsPlaceholder(
          tags: ref.watch(top15PlaceholderTagsProvider),
        ),
      ),
      // Nothing to show, so don't leave an empty card behind.
      _ => const SizedBox.shrink(),
    };
  }
}
