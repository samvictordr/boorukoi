// Package imports:
import 'package:i18n/i18n.dart';
import 'package:kurumi/kurumi.dart';
import 'package:kurumi/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class AddTagButton extends StatelessWidget {
  const AddTagButton({
    required this.onPressed,
    super.key,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return KurumiPill(
      icon: Symbols.add,
      label: context.t.generic.action.add,
      onTap: onPressed,
    );
  }
}
