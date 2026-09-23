// Package imports:
import 'package:i18n/i18n.dart';
import 'package:kurumi/kurumi.dart';
import 'package:kurumi/material.dart';

// Project imports:

class UserDetailsTabView extends StatelessWidget {
  const UserDetailsTabView({
    required this.sliverInfoOverview,
    this.infoDetails,
    super.key,
    this.uploads,
    this.tagChanges,
  });

  final Widget sliverInfoOverview;
  final Widget? infoDetails;
  final Widget? uploads;
  final Widget? tagChanges;

  @override
  Widget build(BuildContext context) {
    final tabMap = {
      context.t.profile.tabs.info: ?infoDetails,
      context.t.profile.tabs.uploads: ?uploads,
      context.t.profile.tabs.changes: ?tagChanges,
    };

    final disableAnimation = context.isLargeScreen;

    return UserDetailsViewScaffold(
      sliverInfoOverview: sliverInfoOverview,
      body: tabMap.isEmpty
          ? Center(child: Text(context.t.generic.no_content))
          : DefaultTabController(
              length: tabMap.length,
              animationDuration: disableAnimation ? Duration.zero : null,
              child: Column(
                children: [
                  TabBar(
                    labelPadding: const EdgeInsets.symmetric(horizontal: 12),
                    isScrollable: true,
                    tabs: [
                      for (final tab in tabMap.keys) Tab(text: tab),
                    ],
                  ),
                  const Divider(thickness: 1, height: 0),
                  Expanded(
                    child: TabBarView(
                      physics: disableAnimation
                          ? const NeverScrollableScrollPhysics()
                          : null,
                      children: [
                        for (final tab in tabMap.values) tab,
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class UserDetailsViewScaffold extends StatelessWidget {
  const UserDetailsViewScaffold({
    required this.sliverInfoOverview,
    required this.body,
    super.key,
  });

  final Widget sliverInfoOverview;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Kurumi.themeOf(context).colorScheme.surface,
        borderRadius: const BorderRadius.all(Radius.circular(KurumiRadius.sm)),
      ),
      child: CustomScrollView(
        slivers: [
          sliverInfoOverview,
          SliverFillRemaining(
            child: body,
          ),
        ],
      ),
    );
  }
}

class UserOverviewScaffold extends StatelessWidget {
  const UserOverviewScaffold({
    required this.userInfo,
    required this.action,
    super.key,
    this.isSelf = false,
  });

  final bool isSelf;
  final Widget userInfo;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: userInfo,
          ),
          if (isSelf) const SizedBox(height: 12),
          if (isSelf) action,
        ],
      ),
    );
  }
}
