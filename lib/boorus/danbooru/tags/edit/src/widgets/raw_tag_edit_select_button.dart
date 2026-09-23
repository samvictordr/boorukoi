// Package imports:
import 'package:kurumi/kurumi.dart';
import 'package:kurumi/material.dart';

class RawTagEditSelectButton extends StatelessWidget {
  const RawTagEditSelectButton({
    required this.title,
    required this.onPressed,
    super.key,
  });

  final void Function() onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(KurumiRadius.xs)),
        ),
        backgroundColor: Kurumi.themeOf(
          context,
        ).colorScheme.surfaceContainerHighest,
      ),
      onPressed: onPressed,
      child: Text(
        title,
        style: TextStyle(
          color: Kurumi.themeOf(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
