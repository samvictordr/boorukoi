// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kurumi/kurumi.dart';
import 'package:kurumi/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

// Project imports:
import 'booru_chip.dart';
import 'option_searchable_sheet.dart';

sealed class OptionSelectorItem {
  const OptionSelectorItem();
}

final class ButtonType extends OptionSelectorItem {
  const ButtonType();
}

final class OptionType<T> extends OptionSelectorItem {
  const OptionType({required this.data});

  final T data;
}

class ChoiceOptionSelectorList<T> extends ConsumerStatefulWidget {
  const ChoiceOptionSelectorList({
    required this.options,
    required this.selectedOption,
    required this.optionLabelBuilder,
    super.key,
    this.icon,
    this.onSelected,
    this.sheetTitle,
    this.hasNullOption = true,
    this.searchable = true,
    this.padding,
    this.scrollController,
  });

  final List<T> options;
  final T? selectedOption;
  final Widget? icon;
  final void Function(T? value)? onSelected;
  final String? sheetTitle;
  final String Function(T? value) optionLabelBuilder;
  final bool hasNullOption;
  final bool searchable;
  final EdgeInsetsGeometry? padding;
  final AutoScrollController? scrollController;

  @override
  ConsumerState<ChoiceOptionSelectorList<T>> createState() =>
      _ChoiceOptionSelectorListState();
}

class _ChoiceOptionSelectorListState<T>
    extends ConsumerState<ChoiceOptionSelectorList<T>> {
  late final scrollController =
      widget.scrollController ?? AutoScrollController();
  late var selectedOption = widget.selectedOption;

  @override
  void didUpdateWidget(covariant ChoiceOptionSelectorList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.selectedOption != widget.selectedOption) {
      selectedOption = widget.selectedOption;
    }
  }

  @override
  void dispose() {
    super.dispose();

    if (widget.scrollController == null) {
      scrollController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final options = <OptionSelectorItem?>[
      if (widget.searchable) const ButtonType(),
      if (widget.hasNullOption) null,
      ...widget.options.map((e) => OptionType(data: e)),
    ];

    final colorScheme = Kurumi.themeOf(context).colorScheme;

    return Container(
      height: 32,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListView.builder(
        padding: widget.padding,
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: options.length,
        itemBuilder: (context, index) {
          final value = options[index];
          final selected = switch (value) {
            ButtonType _ => false,
            final OptionType o => o.data == selectedOption,
            null => selectedOption == null,
          };

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: switch (value) {
              null => _buildOption(
                value: null,
                index: index,
                total: options.length,
                selected: selected,
                colorScheme: colorScheme,
              ),
              final OptionType option => _buildOption(
                value: option.data as T,
                index: index,
                total: options.length,
                selected: selected,
                colorScheme: colorScheme,
              ),
              ButtonType _ => _buildSearchButton(context, options),
            },
          );
        },
      ),
    );
  }

  Widget _buildOption({
    required T? value,
    required int index,
    required int total,
    required bool selected,
    required ColorScheme colorScheme,
  }) {
    final label = widget.optionLabelBuilder(value);

    void select() => _onSelect(value, index, total);

    return Semantics(
      label: label,
      selected: selected,
      button: true,
      enabled: true,
      onTap: select,
      excludeSemantics: true,
      child: AutoScrollTag(
        controller: scrollController,
        index: index,
        key: ValueKey(index),
        child: BooruChip(
          borderRadius: KurumiBorderRadius.sm,
          disabled: !selected,
          color: selected ? colorScheme.onSurface : colorScheme.hintColor,
          onPressed: select,
          label: Text(
            label,
            style: TextStyle(
              color: selected ? null : colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchButton(
    BuildContext context,
    List<OptionSelectorItem?> options,
  ) {
    void showSearch() {
      final items = options.whereType<OptionType<T>>().toList();
      Kurumi.showAppModalBarBottomSheet(
        context: context,
        settings: const RouteSettings(
          name: 'choice_option_selector',
        ),
        duration: const Duration(milliseconds: 300),
        builder: (context) => OptionSearchableSheet(
          title: widget.sheetTitle,
          items: items,
          scrollController: ModalScrollController.of(context),
          onFilter: (query) => items.where((e) {
            final value = widget.optionLabelBuilder(e.data);

            return value.toLowerCase().contains(
              query.toLowerCase(),
            );
          }).toList(),
          itemBuilder: (context, option) => ListTile(
            minVerticalPadding: 4,
            title: Text(
              widget.optionLabelBuilder(option.data),
            ),
            onTap: () {
              Navigator.pop(context);
              final valueIndex = options.indexOf(option);
              _onSelect(
                option.data,
                valueIndex,
                options.length,
              );
            },
          ),
        ),
      );
    }

    return Semantics(
      button: true,
      onTap: showSearch,
      child: IconButton(
        iconSize: 20,
        onPressed: showSearch,
        icon: widget.icon ?? const Icon(Symbols.tune),
      ),
    );
  }

  void _onSelect(T? value, int index, int total) {
    // Attempt to scroll to an adjacent index to make it obvious that there
    // are still more options.
    final targetIndex = index + 1;
    final effectiveIndex = targetIndex < total ? targetIndex : index;

    widget.onSelected?.call(value);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      scrollController.scrollToIndex(
        effectiveIndex,
        preferPosition: AutoScrollPosition.end,
        duration: const Duration(milliseconds: 300),
      );
    });
  }
}
