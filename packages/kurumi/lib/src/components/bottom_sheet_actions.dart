import 'package:material_ui/material_ui.dart';
import '../theme/shapes.dart';

class KurumiBottomSheetActionButtons extends StatelessWidget {
  const KurumiBottomSheetActionButtons({
    required this.secondaryChild,
    required this.primaryChild,
    required this.onSecondaryPressed,
    required this.onPrimaryPressed,
    super.key,
  });

  final Widget secondaryChild;
  final Widget primaryChild;
  final VoidCallback? onSecondaryPressed;
  final VoidCallback? onPrimaryPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      spacing: 16,
      children: [
        Expanded(
          flex: 3,
          child: ElevatedButton(
            style: FilledButton.styleFrom(
              disabledBackgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: KurumiBorderRadius.full,
                side: BorderSide(color: colorScheme.outline),
              ),
            ),
            onPressed: onSecondaryPressed,
            child: secondaryChild,
          ),
        ),
        Expanded(
          flex: 5,
          child: FilledButton(
            style: FilledButton.styleFrom(
              foregroundColor: colorScheme.onPrimary,
              shape: const RoundedRectangleBorder(
                borderRadius: KurumiBorderRadius.full,
              ),
            ),
            onPressed: onPrimaryPressed,
            child: primaryChild,
          ),
        ),
      ],
    );
  }
}
