// Package imports:
import 'package:kurumi/kurumi.dart';
import 'package:kurumi/material.dart';

class ProgressStepper extends StatelessWidget {
  const ProgressStepper({
    required this.current,
    required this.max,
    required this.color,
    super.key,
  });

  final int current;
  final int max;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: KurumiBorderRadius.sm,
      child: LinearProgressIndicator(
        value: current / max,
        color: color,
        minHeight: 8,
      ),
    );
  }
}
