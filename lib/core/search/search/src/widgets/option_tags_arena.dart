// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kurumi/material.dart';
import 'package:material_symbols_icons/symbols.dart';

// Project imports:
import '../../../../widgets/search_section_card.dart';

class OptionTagsArenaController extends ChangeNotifier {
  final ValueNotifier<bool> editMode = ValueNotifier(false);

  void toggleEditMode() {
    editMode.value = !editMode.value;
    notifyListeners();
  }
}

class OptionTagsArena extends ConsumerStatefulWidget {
  const OptionTagsArena({
    required this.title,
    required this.children,
    super.key,
    this.titleTrailing,
    this.editable = true,
    this.controller,
  });

  final String title;
  final Widget? titleTrailing;
  final List<Widget> children;
  final bool editable;
  final OptionTagsArenaController? controller;

  @override
  ConsumerState<OptionTagsArena> createState() => _OptionTagsArenaState();
}

class _OptionTagsArenaState extends ConsumerState<OptionTagsArena> {
  late final controller = widget.controller ?? OptionTagsArenaController();

  @override
  void dispose() {
    if (widget.controller == null) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SearchSectionCard(
      title: widget.title,
      trailing: widget.titleTrailing,
      actions: [
        if (widget.editable)
          ValueListenableBuilder(
            valueListenable: controller.editMode,
            builder: (context, editMode, _) => SearchSectionActionButton(
              icon: editMode ? Symbols.check : Symbols.edit,
              selected: editMode,
              onPressed: controller.toggleEditMode,
            ),
          ),
      ],
      child: SearchPillWrap(children: widget.children),
    );
  }
}
