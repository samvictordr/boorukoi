import 'package:material_ui/material_ui.dart';

import '../theme/spacing.dart';

class KurumiErrorBox extends StatelessWidget {
  const KurumiErrorBox({
    required this.illustration,
    required this.errorMessage,
    required this.retryLabel,
    super.key,
    this.onRetry,
    this.altAction,
  });

  final Widget illustration;
  final String errorMessage;
  final String retryLabel;
  final VoidCallback? onRetry;
  final Widget? altAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 50),
        illustration,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Semantics(
            liveRegion: true,
            child: Text(
              errorMessage,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ?altAction,
              if (onRetry case final onRetry?)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  width: constraints.maxWidth <= 450
                      ? constraints.maxWidth
                      : null,
                  constraints: const BoxConstraints(
                    maxWidth: 450,
                  ),
                  child: FilledButton(
                    onPressed: onRetry,
                    child: Text(retryLabel),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class KurumiNoDataBox extends StatelessWidget {
  const KurumiNoDataBox({
    required this.illustration,
    required this.message,
    super.key,
  });

  final Widget illustration;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 50),
        illustration,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Semantics(
            liveRegion: true,
            child: Text(
              message,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}

/// Centered empty or error state: a tinted symbol, a title, an optional
/// explanation and an optional next step.
class KurumiEmptyState extends StatelessWidget {
  const KurumiEmptyState({
    required this.icon,
    required this.title,
    super.key,
    this.message,
    this.action,
    this.details,
    this.tone = KurumiEmptyStateTone.neutral,
  });

  final IconData icon;
  final String title;
  final String? message;

  /// Usually a button that lets the user recover, such as retry.
  final Widget? action;

  /// Extra content below the action, such as collapsible technical details.
  final Widget? details;
  final KurumiEmptyStateTone tone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final accent = switch (tone) {
      KurumiEmptyStateTone.neutral => colorScheme.onSurfaceVariant,
      KurumiEmptyStateTone.error => colorScheme.error,
    };

    return Semantics(
      liveRegion: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: KurumiSpacing.xxxl,
          vertical: KurumiSpacing.xxxl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DecoratedBox(
              decoration: ShapeDecoration(
                shape: const CircleBorder(),
                color: accent.withValues(alpha: 0.1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(KurumiSpacing.xl),
                child: Icon(icon, size: 40, color: accent),
              ),
            ),
            const SizedBox(height: KurumiSpacing.xl),
            Text(
              title,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            if (message case final message?) ...[
              const SizedBox(height: KurumiSpacing.sm),
              Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action case final action?) ...[
              const SizedBox(height: KurumiSpacing.xl),
              action,
            ],
            if (details case final details?) ...[
              const SizedBox(height: KurumiSpacing.sm),
              details,
            ],
          ],
        ),
      ),
    );
  }
}

enum KurumiEmptyStateTone { neutral, error }
