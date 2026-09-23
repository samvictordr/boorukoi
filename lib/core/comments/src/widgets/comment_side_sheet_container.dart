// Package imports:
import 'package:i18n/i18n.dart';
import 'package:kurumi/kurumi.dart';
import 'package:kurumi/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class CommentSideSheetContainer extends StatelessWidget {
  const CommentSideSheetContainer({
    required this.builder,
    super.key,
  });

  final Widget Function(BuildContext context, bool useAppBar) builder;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.only(top: MediaQuery.viewPaddingOf(context).top),
      child: Column(
        children: [
          Container(
            height: kToolbarHeight * 0.8,
            decoration: BoxDecoration(
              color: Kurumi.themeOf(context).colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(KurumiRadius.xs),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const SizedBox(width: 8),
                Text(
                  context.t.comment.comments,
                  style: Kurumi.themeOf(context).textTheme.titleLarge,
                ),
                const Spacer(),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(KurumiRadius.lg),
                    ),
                    onTap: Navigator.of(context).pop,
                    child: const Icon(Symbols.close),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
          Expanded(
            child: builder(context, false),
          ),
        ],
      ),
    );
  }
}
