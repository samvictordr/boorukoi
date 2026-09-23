// Package imports:
import 'package:coreutils/coreutils.dart';
import 'package:kurumi/kurumi.dart';
import 'package:kurumi/material.dart';

class BooruVersionChip extends StatelessWidget {
  const BooruVersionChip({
    required this.version,
    super.key,
  });

  final Version version;

  @override
  Widget build(BuildContext context) {
    final versionText = 'v$version';

    return Semantics(
      label: versionText,
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 2,
        ),
        margin: const EdgeInsets.only(
          left: 4,
        ),
        decoration: BoxDecoration(
          borderRadius: KurumiBorderRadius.md,
          color: Kurumi.themeOf(context).colorScheme.surfaceContainer,
        ),
        child: Text(
          versionText,
          style: TextStyle(
            color: Kurumi.themeOf(context).colorScheme.onSurface,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
