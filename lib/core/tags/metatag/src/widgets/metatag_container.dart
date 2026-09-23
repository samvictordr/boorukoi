// Package imports:
import 'package:kurumi/kurumi.dart';
import 'package:kurumi/material.dart';
import 'package:rich_text_controller/rich_text_controller.dart';

class MetatagContainer extends StatelessWidget {
  const MetatagContainer({
    super.key,
    required this.tag,
  });

  final String tag;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Kurumi.themeOf(context).colorScheme;

    return TextContainer(
      text: tag,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(KurumiRadius.xs),
          bottomLeft: Radius.circular(KurumiRadius.xs),
        ),
      ),
    );
  }
}
