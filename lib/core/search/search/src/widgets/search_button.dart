// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kurumi/kurumi.dart';
import 'package:kurumi/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class SearchButton extends ConsumerWidget {
  const SearchButton({
    required this.onSearch,
    required this.allowSearch,
    super.key,
  });

  final VoidCallback onSearch;
  final bool allowSearch;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return allowSearch
        ? FloatingActionButton(
            onPressed: onSearch,
            heroTag: null,
            child: const Icon(Symbols.search),
          )
        : const SizedBox.shrink();
  }
}

class SearchButton2 extends StatelessWidget {
  const SearchButton2({
    required this.onTap,
    super.key,
  });

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: Material(
        color: onTap == null
            ? Kurumi.themeOf(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.1)
            : Kurumi.themeOf(context).colorScheme.primary,
        borderRadius: KurumiBorderRadius.sm,
        child: InkWell(
          customBorder: const RoundedRectangleBorder(
            borderRadius: KurumiBorderRadius.sm,
          ),
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.all(4),
            child: Icon(
              Symbols.search,
              color: Kurumi.themeOf(context).colorScheme.onPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
