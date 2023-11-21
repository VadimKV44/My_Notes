import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_notes/View/consts/colors.dart';
import 'package:my_notes/View/consts/styles.dart';

abstract class Themes {
  static ThemeData lightTheme() => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: LightThemeColors.kColorWhite,
    iconTheme: const IconThemeData(
      color: Colors.black,
    ),
    textTheme: TextTheme(
      titleLarge: LightThemeTextStyles.tabBarLightStyleBlack(24.0),
      titleSmall: LightThemeTextStyles.tabBarLightStyleBlack(24.0),
      headlineSmall: LightThemeTextStyles.kColorBlueGreyW500(16.0),
      bodyMedium: LightThemeTextStyles.kColorGreyW600(17.0),
      labelSmall: LightThemeTextStyles.kColorGreyW800(18.0),
      labelLarge: LightThemeTextStyles.kColorBlueGreyWithOpacityW500(14.0),
      labelMedium: LightThemeTextStyles.kColorGreyWithOpacityW600(17.0),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: LightThemeColors.kColorBlue,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        systemStatusBarContrastEnforced: false,
      ),
    ),
    colorScheme: const ColorScheme.light().copyWith(
      primary: Colors.white,
      secondary: LightThemeColors.kColorBlue,
      outline: LightThemeColors.kColorBlack,
      primaryContainer: LightThemeColors.kColorBlue.withOpacity(0.5),
      secondaryContainer: Colors.white.withOpacity(0.8),
      tertiary: Colors.black.withOpacity(0.5),
      background: LightThemeColors.kColorWhite,
    ),
  );

  static ThemeData darkTheme() => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: DarkThemeColors.kDarkBlue1,
    iconTheme: const IconThemeData(
      color: DarkThemeColors.kColorWhite2,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: DarkThemeColors.kDarkBlue2,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        systemStatusBarContrastEnforced: false,
      ),
    ),
    textTheme: TextTheme(
      titleLarge: DarkThemeTextStyles.tabBarDarkStyleBlack(24.0),
      titleSmall: DarkThemeTextStyles.tabBarDarkStyleBlack(24.0),
      headlineSmall: DarkThemeTextStyles.kColorWhite2W500(16.0),
      bodyMedium: DarkThemeTextStyles.kColorWhiteW600(17.0),
      labelSmall: DarkThemeTextStyles.kColorWhite2W800(18.0),
      labelLarge: DarkThemeTextStyles.kColorWhite2WithOpacityW500(14.0),
      labelMedium: DarkThemeTextStyles.kColorWhiteWithOpacityW600(17.0),
    ),
    colorScheme: const ColorScheme.dark().copyWith(
      primary: DarkThemeColors.kDarkBlue2,
      secondary: DarkThemeColors.kPurple,
      outline: Colors.white,
      primaryContainer: DarkThemeColors.kPurple.withOpacity(0.5),
      secondaryContainer: DarkThemeColors.kDarkBlue2.withOpacity(0.8),
      tertiary: DarkThemeColors.kColorWhite2.withOpacity(0.5),
      background: DarkThemeColors.kPurple,
    ),
  );
}