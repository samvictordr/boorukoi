// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i18n/i18n.dart';
import 'package:kurumi/kurumi.dart';
import 'package:kurumi/material.dart';
import 'package:material_symbols_icons/symbols.dart';

// Project imports:
import '../../../configs/manage/widgets.dart';
import '../../../settings/providers.dart';
import '../controllers/home_page_controller.dart';
import '../types/home_tab.dart';

class HomeNavigationPill extends ConsumerWidget {
  const HomeNavigationPill({
    required this.controller,
    super.key,
  });

  final HomePageController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final position = ref.watch(
      settingsProvider.select((value) => value.booruConfigSelectorPosition),
    );

    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, value, _) => KurumiFloatingNavBar(
        header: position.isBottom ? const _BooruSelectorCapsule() : null,
        selectedIndex: HomeTab.fromViewIndex(value)?.index,
        onSelected: (index) => switch (HomeTab.values[index]) {
          HomeTab(viewIndex: final int viewIndex) => controller.goToTab(
            viewIndex,
          ),
          HomeTab() => controller.openMenu(),
        },
        items: [
          for (final tab in HomeTab.values) _itemOf(context, tab),
        ],
      ),
    );
  }

  KurumiFloatingNavItem _itemOf(BuildContext context, HomeTab tab) =>
      switch (tab) {
        HomeTab.home => KurumiFloatingNavItem(
          icon: const Icon(Symbols.home),
          label: context.t.sideMenu.home,
        ),
        HomeTab.bookmarks => KurumiFloatingNavItem(
          icon: const Icon(Symbols.bookmark),
          label: context.t.bookmark.title,
        ),
        HomeTab.downloads => KurumiFloatingNavItem(
          icon: const Icon(Symbols.download),
          label: context.t.download.downloads,
        ),
        HomeTab.more => KurumiFloatingNavItem(
          icon: const Icon(Symbols.menu),
          label: context.t.generic.action.more,
        ),
      };
}

class _BooruSelectorCapsule extends ConsumerWidget {
  const _BooruSelectorCapsule();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hideLabel = ref.watch(
      settingsProvider.select(
        (value) => value.booruConfigLabelVisibility.hideBooruConfigLabel,
      ),
    );

    return KurumiGlass(
      shape: KurumiShapes.xl,
      elevated: true,
      child: SizedBox(
        height: kBottomNavigationBarHeight - (hideLabel ? 4 : -8),
        child: const BooruSelector(
          direction: Axis.horizontal,
        ),
      ),
    );
  }
}
