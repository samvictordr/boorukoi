// Package imports:
import 'package:kurumi/kurumi.dart';
import 'package:kurumi/material.dart';

// Project imports:

class DataTransferCard extends StatelessWidget {
  const DataTransferCard({
    required this.icon,
    required this.title,
    required this.onPressed,
    super.key,
  });

  final Widget icon;
  final String title;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Kurumi.themeOf(context);
    final iconTheme = theme.iconTheme;
    const borderRadius = KurumiBorderRadius.lg;

    return Material(
      color: Kurumi.themeOf(context).colorScheme.surfaceContainer,
      shape: const RoundedRectangleBorder(
        borderRadius: borderRadius,
      ),
      child: InkWell(
        customBorder: const RoundedRectangleBorder(
          borderRadius: borderRadius,
        ),
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  shape: BoxShape.circle,
                ),
                child: Theme(
                  data: theme.copyWith(
                    iconTheme: iconTheme.copyWith(
                      size: 18,
                      color: theme.colorScheme.hintColor,
                    ),
                  ),
                  child: icon,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
