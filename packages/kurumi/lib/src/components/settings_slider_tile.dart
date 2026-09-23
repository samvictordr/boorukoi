import 'package:material_ui/material_ui.dart';

import 'slider.dart';

class KurumiSettingsSliderTile extends StatelessWidget {
  const KurumiSettingsSliderTile({
    required this.title,
    required this.value,
    required this.divisions,
    required this.max,
    required this.onChanged,
    required this.onChangeEnd,
    super.key,
    this.min = 0.0,
    this.padding,
  });

  final String title;
  final double value;
  final int divisions;
  final double min;
  final double max;
  final void Function(double) onChanged;
  final void Function(double) onChangeEnd;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatted = _formatValue(value);

    return Padding(
      padding:
          padding ??
          const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 12,
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.bodyLarge,
                ),
              ),
              Text(
                formatted,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          KurumiSlider(
            label: formatted,
            divisions: divisions,
            max: max,
            min: min,
            value: value,
            onChangeEnd: onChangeEnd,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

String _formatValue(double value) => value == value.roundToDouble()
    ? value.toStringAsFixed(0)
    : value.toStringAsFixed(1);
