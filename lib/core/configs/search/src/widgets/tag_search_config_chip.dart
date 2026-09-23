// Package imports:
import 'package:kurumi/kurumi.dart';
import 'package:kurumi/material.dart';

class TagSearchConfigChip extends StatelessWidget {
  const TagSearchConfigChip({
    required this.tag,
    super.key,
    this.backgroundColor,
  });

  final String tag;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Kurumi.themeOf(context).colorScheme;

    return KurumiRawCompactChip(
      padding: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 8,
      ),
      label: RichText(
        text: TextSpan(
          children: [
            if (tag.startsWith('-'))
              TextSpan(
                text: '—',
                style: TextStyle(
                  color: colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            TextSpan(
              text: tag.startsWith('-') ? tag.substring(1) : tag,
              style: TextStyle(
                color: colorScheme.onSecondaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: backgroundColor ?? colorScheme.secondaryContainer,
      shape: const RoundedRectangleBorder(
        borderRadius: KurumiBorderRadius.xs,
      ),
    );
  }
}
