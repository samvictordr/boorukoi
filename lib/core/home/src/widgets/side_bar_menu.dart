// Dart imports:
import 'dart:math';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i18n/i18n.dart';
import 'package:kurumi/kurumi.dart';
import 'package:kurumi/material.dart';
import 'package:material_symbols_icons/symbols.dart';

// Project imports:
import '../../../../foundation/boot/providers.dart';
import '../../../blacklists/routes.dart';
import '../../../bookmarks/routes.dart';
import '../../../bulk_downloads/routes.dart';
import '../../../configs/config/providers.dart';
import '../../../configs/manage/widgets.dart';
import '../../../donate/routes.dart';
import '../../../download_manager/routes.dart';
import '../../../premiums/providers.dart';
import '../../../premiums/routes.dart';
import '../../../premiums/types.dart';
import '../../../search/search/routes.dart';
import '../../../settings/providers.dart';
import '../../../settings/routes.dart';
import '../../../tags/favorites/routes.dart';
import '../../constants.dart';
import '../types/custom_home.dart';
import 'side_menu_tile.dart';

class SideBarMenu extends ConsumerWidget {
  const SideBarMenu({
    super.key,
    this.width,
    this.initialContent,
    this.content,
    this.padding,
  });

  final double? width;
  final EdgeInsets? padding;
  final List<Widget>? initialContent;
  final List<Widget>? content;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final position = ref.watch(
      settingsProvider.select((value) => value.booruConfigSelectorPosition),
    );
    final viewKey = ref.watch(customHomeViewKeyProvider);
    final hasPremium = ref.watch(hasPremiumProvider);
    final theme = Kurumi.themeOf(context);
    final colorScheme = theme.colorScheme;
    final viewPadding = MediaQuery.viewPaddingOf(context);
    final hasConfigs = ref.watch(hasBooruConfigsProvider);
    final isFossBuild = ref.watch(isFossBuildProvider);

    final coreItems = <Widget>[
      if (viewKey != null && viewKey.isAlt)
        SideMenuTile(
          icon: const Icon(Symbols.search),
          title: Text(context.t.settings.search.search),
          onTap: () {
            goToSearchPage(ref);
          },
        ),
      SideMenuTile(
        icon: const Icon(Symbols.favorite),
        title: Text(context.t.sideMenu.your_bookmarks),
        onTap: () {
          goToBookmarkPage(ref);
        },
      ),
      SideMenuTile(
        icon: const Icon(Symbols.list),
        title: Text(context.t.sideMenu.your_blacklist),
        onTap: () {
          goToGlobalBlacklistedTagsPage(ref);
        },
      ),
      SideMenuTile(
        icon: const Icon(Symbols.tag),
        title: Text(context.t.favorite_tags.title),
        onTap: () {
          goToFavoriteTagsPage(ref);
        },
      ),
      SideMenuTile(
        icon: const Icon(Symbols.sim_card_download),
        title: Text(context.t.sideMenu.bulk_download),
        onTap: () {
          goToBulkDownloadPage(
            context,
            null,
            ref: ref,
          );
        },
      ),
      SideMenuTile(
        icon: const Icon(Symbols.download),
        title: Text(context.t.sideMenu.download_manager),
        onTap: () {
          goToDownloadManagerPage(ref);
        },
      ),
    ];

    final footerItems = <Widget>[
      if (isFossBuild)
        SideMenuTile(
          icon: const Icon(
            Symbols.favorite,
            fill: 1,
            color: Colors.red,
          ),
          title: Text(context.t.donation.donate),
          onTap: () {
            goToDonationPage(ref);
          },
        )
      else if (ref.watch(showPremiumFeatsProvider) &&
          !kForcePremium &&
          !hasPremium)
        SideMenuTile(
          icon: const Icon(
            Symbols.favorite,
            fill: 1,
            color: Colors.red,
          ),
          title: Text(
            context.t.premium.get_premium(
              brand: kPremiumBrandName,
            ),
          ),
          onTap: () {
            goToPremiumPage(ref);
          },
        ),
      SideMenuTile(
        icon: const Icon(
          Symbols.question_mark,
          fill: 1,
        ),
        title: Text(context.t.sideMenu.get_support),
        onTap: () {
          goToSettingsPage(ref, scrollTo: 'support');
        },
      ),
      SideMenuTile(
        icon: const Icon(
          Symbols.settings,
          fill: 1,
        ),
        title: Text(context.t.sideMenu.settings),
        onTap: () {
          goToSettingsPage(ref);
        },
      ),
    ];

    // Floats as an inset glass panel, matching the navigation pill.
    return Padding(
      padding: EdgeInsets.fromLTRB(
        KurumiSpacing.sm,
        viewPadding.top + KurumiSpacing.sm,
        0,
        viewPadding.bottom + KurumiSpacing.sm,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints.expand(
          width: min(MediaQuery.sizeOf(context).width * 0.85, 400),
        ),
        child: KurumiGlass(
          shape: KurumiShapes.xl,
          thickness: KurumiGlassThickness.thick,
          elevated: true,
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            removeBottom: true,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (position.isSide)
                  ColoredBox(
                    color: colorScheme.onSurface.withValues(alpha: 0.04),
                    child: const Padding(
                      padding: EdgeInsets.only(top: KurumiSpacing.sm),
                      child: BooruSelector(),
                    ),
                  ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                      vertical: KurumiSpacing.md,
                    ),
                    children: [
                      if (hasConfigs)
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: KurumiSpacing.sm,
                          ),
                          child: CurrentBooruTile(
                            minWidth: kMinSideBarWidth,
                          ),
                        )
                      else
                        const SizedBox(height: KurumiSpacing.xl),
                      const SizedBox(height: KurumiSpacing.sm),
                      if (initialContent case final items?
                          when items.isNotEmpty)
                        _MenuGroup(children: items),
                      _MenuGroup(children: content ?? coreItems),
                      if (content == null) _MenuGroup(children: footerItems),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A rounded group of menu rows on the glass panel.
class _MenuGroup extends StatelessWidget {
  const _MenuGroup({
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Kurumi.themeOf(context).colorScheme;

    return Container(
      margin: const EdgeInsets.fromLTRB(
        KurumiSpacing.sm,
        0,
        KurumiSpacing.sm,
        KurumiSpacing.md,
      ),
      padding: const EdgeInsets.all(KurumiSpacing.xs),
      decoration: ShapeDecoration(
        shape: KurumiShapes.md,
        color: colorScheme.onSurface.withValues(alpha: 0.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}
