/// Core views are placed after this offset in the home view stack so booru
/// specific views can occupy the indices before it.
const kHomeCoreViewOffset = 100;

int homeCoreViewIndex(int value) => kHomeCoreViewOffset + value;

/// Destinations shown in the floating navigation pill.
enum HomeTab {
  home,
  bookmarks,
  downloads,
  more;

  /// Index of the view in the home view stack, or null when the tab performs
  /// an action instead of switching views.
  int? get viewIndex => switch (this) {
    home => 0,
    bookmarks => homeCoreViewIndex(2),
    downloads => homeCoreViewIndex(6),
    more => null,
  };

  static HomeTab? fromViewIndex(int index) =>
      values.where((tab) => tab.viewIndex == index).firstOrNull;
}
