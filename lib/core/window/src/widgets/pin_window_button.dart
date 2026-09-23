// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i18n/i18n.dart';
import 'package:kurumi/kurumi.dart';
import 'package:kurumi/material.dart';
import 'package:material_symbols_icons/symbols.dart';

// Project imports:
import '../providers/always_on_top_provider.dart';

class PinWindowButton extends ConsumerWidget {
  const PinWindowButton({
    super.key,
    this.iconSize = 16,
  });

  final double iconSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alwaysOnTop = ref.watch(alwaysOnTopProvider);

    ref.listen(
      alwaysOnTopProvider,
      (prev, next) {
        next.whenData((isPinned) {
          // Avoid showing toast on initial load
          if (prev?.valueOrNull == null) return;

          final message = isPinned
              ? context.t.window.pin.pin_toast
              : context.t.window.pin.unpin_toast;
          Kurumi.showSuccessToast(
            context,
            message,
            icon: isPinned ? Symbols.keep : Symbols.keep_off,
            duration: KurumiDurations.shortToast,
          );
        });
      },
    );

    return alwaysOnTop.maybeWhen(
      data: (isPinned) => _PinButton(
        isPinned: isPinned,
        iconSize: iconSize,
        onPressed: () {
          ref.read(alwaysOnTopProvider.notifier).toggle();
        },
      ),
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _PinButton extends StatelessWidget {
  const _PinButton({
    required this.isPinned,
    required this.onPressed,
    this.iconSize = 16,
  });

  final bool isPinned;
  final VoidCallback onPressed;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      toggled: isPinned,
      onTap: onPressed,
      child: GestureDetector(
        onTap: onPressed,
        child: KurumiHoverAwareContainer(
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Icon(
              isPinned ? Icons.push_pin : Icons.push_pin_outlined,
              size: iconSize,
              color: Kurumi.themeOf(context).colorScheme.outline,
            ),
          ),
        ),
      ),
    );
  }
}
