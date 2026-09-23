import 'package:material_ui/material_ui.dart';

import 'settings_section.dart';

class KurumiSettingsHeader extends StatelessWidget {
  const KurumiSettingsHeader({
    required this.label,
    super.key,
    this.padding = const EdgeInsets.only(top: 16),
  });

  final String label;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: KurumiSettingsSectionHeader(label: label),
    );
  }
}
