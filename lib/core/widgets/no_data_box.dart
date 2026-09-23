// Package imports:
import 'package:i18n/i18n.dart';
import 'package:kurumi/kurumi.dart';
import 'package:kurumi/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class NoDataBox extends StatelessWidget {
  const NoDataBox({super.key});

  @override
  Widget build(BuildContext context) {
    return KurumiEmptyState(
      icon: Symbols.image_search,
      title: context.t.generic.errors.no_data,
    );
  }
}
