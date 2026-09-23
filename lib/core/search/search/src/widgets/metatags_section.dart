// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kurumi/kurumi.dart';
import 'package:kurumi/material.dart';
import 'package:material_symbols_icons/symbols.dart';

// Project imports:
import '../../../../tags/metatag/routes.dart';
import '../../../../tags/metatag/types.dart';
import 'add_tag_button.dart';
import 'option_tags_arena.dart';
import '../../../../widgets/search_section_card.dart';

class MetatagsSection extends ConsumerStatefulWidget {
  const MetatagsSection({
    required this.onOptionTap,
    required this.metatags,
    required this.userMetatags,
    required this.onUserMetatagDeleted,
    required this.onUserMetatagAdded,
    super.key,
    this.onHelpRequest,
  });

  final ValueChanged<String>? onOptionTap;
  final List<Metatag> metatags;
  final List<String>? userMetatags;
  final void Function()? onHelpRequest;
  final Future<void> Function(String tag) onUserMetatagDeleted;
  final Future<void> Function(Metatag tag) onUserMetatagAdded;

  @override
  ConsumerState<MetatagsSection> createState() => _MetatagsSectionState();
}

class _MetatagsSectionState extends ConsumerState<MetatagsSection> {
  final controller = OptionTagsArenaController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userMetatags = widget.userMetatags;

    return OptionTagsArena(
      controller: controller,
      title: 'Metatags',
      titleTrailing: switch (widget.onHelpRequest) {
        final onHelpRequest? => SearchSectionActionButton(
          icon: Symbols.help,
          onPressed: onHelpRequest,
        ),
        null => null,
      },
      children: [
        if (userMetatags != null)
          ...userMetatags.map(
            (tag) => ValueListenableBuilder(
              valueListenable: controller.editMode,
              builder: (context, editMode, _) => _buildChip(tag, editMode),
            ),
          ),
        ValueListenableBuilder(
          valueListenable: controller.editMode,
          builder: (context, editMode, _) =>
              _buildAddButton(context, widget.metatags),
        ),
      ],
    );
  }

  Widget _buildChip(String tag, bool editMode) {
    return KurumiPill(
      label: tag,
      tone: KurumiPillTone.accent,
      onTap: editMode ? null : () => widget.onOptionTap?.call(tag),
      onDelete: editMode ? () => widget.onUserMetatagDeleted(tag) : null,
    );
  }

  Widget _buildAddButton(BuildContext context, List<Metatag> metatags) {
    return AddTagButton(
      onPressed: () => goToMetatagsPage(
        context,
        metatags: metatags,
        onSelected: (tag) {
          widget.onUserMetatagAdded(tag);
        },
      ),
    );
  }
}
