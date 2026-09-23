// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i18n/i18n.dart';
import 'package:kurumi/kurumi.dart';
import 'package:kurumi/material.dart';
import 'package:material_symbols_icons/symbols.dart';

// Project imports:
import '../../../../cache/providers.dart';
import '../../../../router.dart';
import '../../../../tags/favorites/types.dart';
import '../../../../tags/favorites/widgets.dart';
import '../../../selected_tags/types.dart';
import 'constants.dart';
import '../../../../widgets/search_section_card.dart';

class FavoriteTagsSection extends ConsumerWidget {
  const FavoriteTagsSection({
    required this.selectedLabel,
    required this.onTagTap,
    super.key,
  });

  final String selectedLabel;
  final ValueChanged<FavoriteTag>? onTagTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(
      miscDataProvider(kSearchSelectedFavoriteTagLabelKey).notifier,
    );

    return FavoriteTagsFilterScope(
      initialValue: selectedLabel,
      sortType: FavoriteTagsSortType.nameAZ,
      builder: (_, tags, labels, selected) => OptionTagsArenaNoEdit(
        title: context.t.favorite_tags.favorites,
        titleTrailing: FavoriteTagLabelSelectorField(
          selected: selected,
          labels: labels,
          onSelect: (value) => notifier.put(value),
        ),
        children: _buildFavoriteTags(ref, tags),
      ),
    );
  }

  List<Widget> _buildFavoriteTags(
    WidgetRef ref,
    List<FavoriteTag> tags,
  ) {
    return [
      for (final tag in tags)
        KurumiPill(
          label: tag.name,
          icon: tag.queryType == QueryType.simple ? Symbols.code : null,
          onTap: () => onTagTap?.call(tag),
        ),
      if (tags.isEmpty) ...[
        const ImportTagButton(),
      ],
    ];
  }
}

class OptionTagsArenaNoEdit extends ConsumerWidget {
  const OptionTagsArenaNoEdit({
    required this.title,
    required this.children,
    super.key,
    this.titleTrailing,
  });

  final String title;
  final Widget? titleTrailing;
  final List<Widget> children;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SearchSectionCard(
      title: title,
      trailing: titleTrailing,
      actions: [
        SearchSectionActionButton(
          icon: Symbols.settings,
          onPressed: () => ref.router.push('/favorite_tags'),
        ),
      ],
      child: SearchPillWrap(children: children),
    );
  }
}

class ImportTagButton extends StatelessWidget {
  const ImportTagButton({super.key});

  @override
  Widget build(BuildContext context) {
    return KurumiPill(
      icon: Symbols.download,
      label: context.t.settings.backup_and_restore.import,
      tone: KurumiPillTone.accent,
      onTap: () => goToFavoriteTagImportPage(context),
    );
  }
}
