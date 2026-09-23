// Dart imports:
import 'dart:math';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foundation/foundation.dart';
import 'package:kurumi/kurumi.dart';
import 'package:kurumi/material.dart';
import 'package:material_symbols_icons/symbols.dart';

// Project imports:
import '../../routes.dart';

enum QuickSearchInsertMode {
  insertAtCursor,
  replace,
}

enum QuickSearchTextFieldLayout {
  standard,
  composer,
}

class QuickSearchTextField extends ConsumerWidget {
  const QuickSearchTextField({
    required this.controller,
    super.key,
    this.autofocus = false,
    this.minLines = 1,
    this.maxLines = 5,
    this.maxLength,
    this.textInputAction,
    this.decoration = const InputDecoration(),
    this.showInputSelector = true,
    this.quickSearchInsertMode = QuickSearchInsertMode.insertAtCursor,
    this.layout = QuickSearchTextFieldLayout.standard,
    this.composerTrailing,
    this.onChanged,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final bool autofocus;
  final int minLines;
  final int maxLines;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final InputDecoration decoration;
  final bool showInputSelector;
  final QuickSearchInsertMode quickSearchInsertMode;
  final QuickSearchTextFieldLayout layout;
  final Widget? composerTrailing;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quickSearchButton = SizedBox.square(
      dimension: 44,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () => _openQuickSearch(context, ref),
          child: const Icon(Symbols.add),
        ),
      ),
    );

    Widget buildTextField(InputDecoration effectiveDecoration) =>
        KurumiTextField(
          controller: controller,
          autofocus: autofocus,
          minLines: minLines,
          maxLines: maxLines,
          maxLength: maxLength,
          textInputAction: textInputAction,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          decoration: effectiveDecoration,
        );

    if (layout == QuickSearchTextFieldLayout.standard) {
      return buildTextField(
        decoration.copyWith(suffixIcon: quickSearchButton),
      );
    }

    final colorScheme = Kurumi.themeOf(context).colorScheme;

    return Material(
      color: colorScheme.surfaceContainerHigh,
      shape: RoundedRectangleBorder(
        borderRadius: KurumiBorderRadius.xl,
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildTextField(
              decoration.copyWith(
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                contentPadding: const EdgeInsets.fromLTRB(8, 12, 8, 4),
              ),
            ),
            Row(
              children: [
                quickSearchButton,
                const Spacer(),
                ?composerTrailing,
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openQuickSearch(BuildContext context, WidgetRef ref) {
    final navigator = Navigator.of(context);

    goToQuickSearchPage(
      context,
      ref: ref,
      showInputSelector: showInputSelector,
      onSelected: (value, _) => _insertValue(value),
      onSubmitted: (context, value, _) {
        navigator.pop();
        _insertValue(value);
      },
    );
  }

  void _insertValue(String value) {
    final trimmedValue = value.trim();
    if (trimmedValue.isEmpty) return;

    switch (quickSearchInsertMode) {
      case QuickSearchInsertMode.insertAtCursor:
        final baseOffset = max(0, controller.selection.baseOffset);
        controller
          ..text = controller.text.addCharAtPosition(trimmedValue, baseOffset)
          ..selection = TextSelection.collapsed(
            offset: baseOffset + trimmedValue.length,
          );
      case QuickSearchInsertMode.replace:
        controller
          ..text = trimmedValue
          ..selection = TextSelection.collapsed(offset: trimmedValue.length);
    }

    onChanged?.call(controller.text);
  }
}
