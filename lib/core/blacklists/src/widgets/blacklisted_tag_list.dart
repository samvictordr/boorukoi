// Package imports:
import 'package:foundation/foundation.dart';
import 'package:i18n/i18n.dart';
import 'package:kurumi/kurumi.dart';
import 'package:kurumi/material.dart';
import 'package:material_symbols_icons/symbols.dart';

// Project imports:
import '../routes/local_routes.dart';
import '../types/utils.dart';
import 'blacklisted_tag_tile.dart';

class BlacklistedTagList extends StatelessWidget {
  const BlacklistedTagList({
    required this.tags,
    required this.onRemoveTag,
    required this.onEditTap,
    required this.limitation,
    super.key,
  });

  final Widget limitation;
  final void Function(String tag) onRemoveTag;
  final void Function(String oldTag, String newTag) onEditTap;
  final List<String>? tags;

  @override
  Widget build(BuildContext context) {
    return tags.toOption().fold(
      () => const Center(child: CircularProgressIndicator()),
      (tags) => tags.isNotEmpty
          ? CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: limitation,
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final tag = tags[index];

                      return BlacklistedTagTile(
                        tag: tag,
                        onRemoveTag: (_) => onRemoveTag(tag),
                        onEditTap: () {
                          goToBlacklistedTagsSearchPage(
                            context,
                            initialTags: tag.split(' '),
                            onSelectDone: (tagItems, currentQuery) {
                              final tagString = joinBlackTagItems(
                                tagItems,
                                currentQuery,
                              );

                              onEditTap(tag, tagString);
                            },
                          );
                        },
                      );
                    },
                    childCount: tags.length,
                  ),
                ),
              ],
            )
          : Center(
              child: KurumiEmptyState(
                icon: Symbols.block,
                title: context.t.blacklist.manage.empty_blacklist,
              ),
            ),
    );
  }
}
