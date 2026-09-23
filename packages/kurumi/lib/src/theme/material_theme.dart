import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

import 'color_tokens.dart';
import 'extended_color_scheme.dart';
import 'shapes.dart';
import 'slider_shapes.dart';
import 'typography.dart';

class KurumiMaterialTheme {
  KurumiMaterialTheme._();

  static ThemeData lightTheme({
    required ColorScheme colorScheme,
    required KurumiExtendedColorScheme extendedColorScheme,
    bool isDesktop = false,
  }) =>
      defaultTheme(
        colorScheme: colorScheme,
        isDesktop: isDesktop,
      ).copyWith(
        brightness: Brightness.light,
        dividerTheme: DividerThemeData(
          color: colorScheme.outlineVariant.withAlpha(60),
          endIndent: 0,
          indent: 0,
        ),
        extensions: [
          extendedColorScheme,
        ],
      );

  static ThemeData darkTheme({
    required ColorScheme colorScheme,
    required KurumiExtendedColorScheme extendedColorScheme,
    bool isDesktop = false,
  }) =>
      defaultTheme(
        colorScheme: colorScheme,
        isDesktop: isDesktop,
      ).copyWith(
        brightness: Brightness.dark,
        dividerTheme: const DividerThemeData(
          endIndent: 0,
          indent: 0,
        ),
        extensions: [
          extendedColorScheme,
        ],
      );

  static ThemeData defaultTheme({
    required ColorScheme colorScheme,
    bool isDesktop = false,
  }) => ThemeData(
    textTheme: KurumiTypography.textTheme,
    splashFactory: NoSplash.splashFactory,
    highlightColor: colorScheme.onSurface.withValues(alpha: 0.08),
    appBarTheme: AppBarTheme(
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      systemOverlayStyle: colorScheme.brightness == Brightness.light
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
      shadowColor: Colors.transparent,
      titleSpacing: isDesktop ? 4 : null,
      centerTitle: !isDesktop,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 17,
        letterSpacing: -0.4,
        color: colorScheme.onSurface,
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      shape: KurumiShapes.sheet,
      clipBehavior: Clip.antiAlias,
      backgroundColor: colorScheme.surfaceContainer,
      surfaceTintColor: Colors.transparent,
      dragHandleColor: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
    ),
    drawerTheme: const DrawerThemeData(
      shape: RoundedSuperellipseBorder(
        borderRadius: BorderRadiusDirectional.horizontal(
          end: Radius.circular(KurumiRadius.xl),
        ),
      ),
    ),
    menuTheme: const MenuThemeData(
      style: MenuStyle(
        shape: WidgetStatePropertyAll(KurumiShapes.md),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: KurumiShapes.md,
    ),
    tooltipTheme: TooltipThemeData(
      decoration: ShapeDecoration(
        color: colorScheme.inverseSurface,
        shape: KurumiShapes.xs,
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      shape: KurumiShapes.xs,
      checkColor: WidgetStateProperty.all(colorScheme.onPrimary),
    ),
    chipTheme: const ChipThemeData(
      shape: StadiumBorder(),
      side: BorderSide.none,
    ),
    cardTheme: const CardThemeData(
      elevation: 0,
      shape: KurumiShapes.md,
    ),
    dialogTheme: DialogThemeData(
      surfaceTintColor: Colors.transparent,
      backgroundColor: colorScheme.surfaceContainer,
      shape: KurumiShapes.lg,
      barrierColor: kKurumiScrimColor,
      titleTextStyle: KurumiTypography.textTheme.titleMedium?.copyWith(
        color: colorScheme.onSurface,
      ),
      contentTextStyle: KurumiTypography.textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      shape: CircleBorder(),
    ),
    iconTheme: IconThemeData(
      color: colorScheme.onSurface,
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(
        color: colorScheme.outline,
      ),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      filled: true,
      enabledBorder: const OutlineInputBorder(
        borderRadius: KurumiBorderRadius.sm,
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: KurumiBorderRadius.sm,
        borderSide: BorderSide(
          color: colorScheme.primary,
          width: 2,
        ),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: KurumiBorderRadius.sm,
        borderSide: BorderSide(
          width: 2,
        ),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: KurumiBorderRadius.sm,
        borderSide: BorderSide(
          width: 2,
        ),
      ),
      contentPadding: const EdgeInsets.all(12),
    ),
    popupMenuTheme: const PopupMenuThemeData(
      surfaceTintColor: Colors.transparent,
      shape: KurumiShapes.md,
    ),
    listTileTheme: ListTileThemeData(
      shape: KurumiShapes.sm,
      subtitleTextStyle: TextStyle(
        color: colorScheme.outline,
      ),
    ),
    colorScheme: colorScheme,
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
      },
    ),
    scrollbarTheme: ScrollbarThemeData(
      thickness: WidgetStateProperty.all(4),
      radius: const Radius.circular(2),
    ),
    sliderTheme: SliderThemeData(
      trackHeight: 1,
      thumbColor: colorScheme.onSurface,
      trackShape: const KurumiCustomSliderTrackShape(),
      thumbShape: const KurumiCustomSliderThumbShape(),
      overlayShape: const KurumiCustomSliderOverlayShape(),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.disabled)) {
            if (states.contains(WidgetState.selected)) {
              return colorScheme.surface.withAlpha(255);
            }
            return colorScheme.onSurface.withAlpha(100);
          }
          if (states.contains(WidgetState.selected)) {
            return colorScheme.onPrimary;
          }
          if (states.contains(WidgetState.pressed)) {
            return colorScheme.onSurfaceVariant;
          }
          if (states.contains(WidgetState.hovered)) {
            return colorScheme.onSurfaceVariant;
          }
          if (states.contains(WidgetState.focused)) {
            return colorScheme.onSurfaceVariant;
          }
          return colorScheme.outline;
        },
      ),
    ),
    tabBarTheme: TabBarThemeData(
      tabAlignment: TabAlignment.start,
      indicatorColor: colorScheme.onSurface,
      indicator: UnderlineTabIndicator(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
        borderSide: BorderSide(
          color: colorScheme.onSurface,
          width: 3,
        ),
      ),
      labelStyle: TextStyle(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.w600,
        fontSize: 15,
        letterSpacing: -0.2,
      ),
      unselectedLabelStyle: TextStyle(
        color: colorScheme.onSurface.withAlpha(127),
        fontWeight: FontWeight.w600,
        fontSize: 15,
        letterSpacing: -0.2,
      ),
      dividerHeight: 0.1,
    ),
  );
}
