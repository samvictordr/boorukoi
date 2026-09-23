// Package imports:
import 'package:kurumi/kurumi.dart';
import 'package:kurumi/material.dart';

class UserDetailsSectionCard extends StatelessWidget {
  const UserDetailsSectionCard({
    required this.child,
    required this.title,
    super.key,
  });

  factory UserDetailsSectionCard.text({
    required Widget child,
    required String title,
    Key? key,
  }) => UserDetailsSectionCard(
    key: key,
    title: Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    ),
    child: child,
  );

  final Widget child;
  final Widget title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Kurumi.themeOf(context).colorScheme.surfaceContainerLow,
        borderRadius: KurumiBorderRadius.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title,
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
