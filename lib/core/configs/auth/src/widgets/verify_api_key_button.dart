// Package imports:
import 'package:i18n/i18n.dart';
import 'package:kurumi/kurumi.dart';
import 'package:kurumi/material.dart';

// Project imports:
import '../../../../widgets/widgets.dart';

class VerifyApiKeyButton extends StatelessWidget {
  const VerifyApiKeyButton({
    required this.loginController,
    required this.apiKeyController,
    required this.onVerify,
    super.key,
  });

  final TextEditingController loginController;
  final TextEditingController apiKeyController;
  final VoidCallback onVerify;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Kurumi.themeOf(context).colorScheme;

    return MultiValueListenableBuilder2(
      first: loginController,
      second: apiKeyController,
      builder: (context, login, apiKey) {
        final isEnabled = login.text.isNotEmpty && apiKey.text.isNotEmpty;

        return Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 2,
          ),
          child: KurumiRawCompactChip(
            onTap: isEnabled ? onVerify : null,
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 2,
            ),
            backgroundColor: isEnabled
                ? colorScheme.primaryContainer
                : colorScheme.surfaceContainerLow,
            foregroundColor: isEnabled
                ? colorScheme.onPrimaryContainer
                : colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            shape: const RoundedRectangleBorder(
              borderRadius: KurumiBorderRadius.sm,
            ),
            label: Text(
              context.t.generic.action.verify,
              style: TextStyle(
                fontWeight: isEnabled ? FontWeight.w600 : FontWeight.w500,
                color: isEnabled
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              ),
            ),
          ),
        );
      },
    );
  }
}
