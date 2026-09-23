// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foundation/foundation.dart';
import 'package:i18n/i18n.dart';
import 'package:kurumi/kurumi.dart';
import 'package:kurumi/material.dart';
import 'package:material_symbols_icons/symbols.dart';

// Project imports:
import '../../../../../../core/widgets/widgets.dart';
import '../../../../../foundation/display/media_query_utils.dart';
import '../../../../../foundation/platform.dart';
import '../../../selected_tags/types.dart';
import '../types/search_history.dart';

class SearchHistorySection extends ConsumerWidget {
  const SearchHistorySection({
    required this.onHistoryTap,
    required this.histories,
    super.key,
    this.onFullHistoryRequested,
    this.maxHistory = 5,
    this.showTime = false,
    this.reverseScheme,
  });

  final ValueChanged<SearchHistory> onHistoryTap;
  final void Function()? onFullHistoryRequested;
  final List<SearchHistory> histories;
  final int maxHistory;
  final bool showTime;
  final bool? reverseScheme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Kurumi.themeOf(context).colorScheme;
    final items = histories.take(maxHistory).toList();

    return histories.isNotEmpty
        ? RemoveLeftPaddingOnLargeScreen(
            child: SearchSectionCard(
              title: context.t.search.history.history,
              trailing: switch (onFullHistoryRequested) {
                final onPressed? => SearchSectionActionButton(
                  icon: Symbols.manage_history,
                  onPressed: onPressed,
                ),
                null => null,
              },
              padding: const EdgeInsets.symmetric(vertical: KurumiSpacing.xs),
              child: Column(
                children: [
                  for (final (index, item) in items.indexed) ...[
                    if (index > 0)
                      Divider(
                        height: 0.5,
                        thickness: 0.5,
                        indent: KurumiSpacing.md,
                        color: colorScheme.outlineVariant.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    Material(
                      color: Colors.transparent,
                      child: ListTile(
                        visualDensity: VisualDensity.compact,
                        shape: const RoundedRectangleBorder(),
                        title: SearchHistoryQueryWidget(
                          history: item,
                          reverseScheme: reverseScheme,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: KurumiSpacing.md,
                        ),
                        onTap: () => onHistoryTap(item),
                        minTileHeight: ref.watch(appPlatformProvider).isDesktop
                            ? 0
                            : null,
                        subtitle: showTime
                            ? DateTooltip(
                                date: item.createdAt,
                                child: Text(
                                  item.createdAt.fuzzify(
                                    locale: Localizations.localeOf(context),
                                  ),
                                ),
                              )
                            : null,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}

class SearchHistoryQueryWidget extends StatelessWidget {
  const SearchHistoryQueryWidget({
    required this.history,
    super.key,
    this.reverseScheme,
  });

  final SearchHistory history;
  final bool? reverseScheme;

  @override
  Widget build(BuildContext context) {
    return switch (history.queryType) {
      QueryType.list => Wrap(
        spacing: 4,
        runSpacing: 4,
        children: history
            .queryAsList()
            .map(
              (e) => IgnorePointer(
                child: KurumiPill(label: e),
              ),
            )
            .toList(),
      ),
      _ => Text(history.query),
    };
  }
}
