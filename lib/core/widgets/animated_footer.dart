// Package imports:
import 'package:kurumi/kurumi.dart';
import 'package:kurumi/material.dart';
import 'package:selection_mode/selection_mode.dart';

class SelectionModeAnimatedFooter extends StatelessWidget {
  const SelectionModeAnimatedFooter({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final behavior = context.kurumiBehavior;

    return SelectionConsumer(
      builder: (context, controller, _) {
        final enable = controller.isActive;

        return SafeArea(
          top: false,
          minimum: const EdgeInsets.only(bottom: KurumiSpacing.sm),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: KurumiSpacing.floatingInset,
            ),
            child: IgnorePointer(
              ignoring: !enable,
              child: AnimatedSlide(
                duration: behavior.effectiveDuration(KurumiMotion.standard),
                curve: enable
                    ? KurumiMotion.standardCurve
                    : KurumiMotion.exitCurve,
                offset: enable ? Offset.zero : const Offset(0, 1.5),
                child: AnimatedOpacity(
                  duration: behavior.effectiveDuration(KurumiMotion.fast),
                  opacity: enable ? 1.0 : 0.0,
                  child: KurumiGlass(
                    shape: KurumiShapes.xl,
                    elevated: true,
                    child: Material(
                      type: MaterialType.transparency,
                      child: child,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
