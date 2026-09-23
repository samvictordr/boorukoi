// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kurumi/kurumi.dart';
import 'package:kurumi/material.dart';

// Project imports:
import '../../../../../foundation/display.dart';
import '../../../../../foundation/utils/flutter_utils.dart';
import '../../../../themes/colors/providers.dart';

class FavoriteTagLabelChip extends ConsumerWidget {
  const FavoriteTagLabelChip({
    required this.label,
    super.key,
  });

  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref
        .watch(booruChipColorsProvider)
        .fromColor(
          Kurumi.themeOf(context).colorScheme.primary,
        );

    return SizedBox(
      height: 28,
      child: KurumiMaterialChip(
        padding: kPreferredLayout.isMobile
            ? const EdgeInsets.all(4)
            : EdgeInsets.zero,
        visualDensity: const ShrinkVisualDensity(),
        backgroundColor: colors?.backgroundColor,
        side: colors != null
            ? BorderSide(
                color: colors.borderColor,
              )
            : null,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(KurumiRadius.sm)),
        ),
        label: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.widthOf(context) * 0.7,
          ),
          child: RichText(
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              text: label,
              style: TextStyle(
                color: colors?.foregroundColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
