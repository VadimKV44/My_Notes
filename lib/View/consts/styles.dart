import 'package:flutter/material.dart';
import 'package:my_notes/View/consts/colors.dart';

abstract class LightThemeTextStyles {

  static TextStyle tabBarLightStyleBlack(double fontSize) {
    return TextStyle(
      fontFamily: 'Manrope',
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      color: LightThemeColors.kColorBlack,
    );
  }

  ///FontWeight W500
  static TextStyle kColorBlueGreyW500(double fontSize) {
    return TextStyle(
      fontFamily: 'Manrope',
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      color: LightThemeColors.kColorBlueGrey,
    );
  }

  static TextStyle kColorBlueGreyWithOpacityW500(double fontSize) {
    return TextStyle(
      fontFamily: 'Manrope',
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      color: LightThemeColors.kColorBlueGrey.withOpacity(0.5),
    );
  }

  ///FontWeight W600
  static TextStyle kColorGreyW600(double fontSize) {
    return TextStyle(
      fontFamily: 'Manrope',
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      color: LightThemeColors.kColorGrey,
    );
  }

  static TextStyle kColorGreyWithOpacityW600(double fontSize) {
    return TextStyle(
      fontFamily: 'Manrope',
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      color: LightThemeColors.kColorGrey2.withOpacity(0.5),
      decoration: TextDecoration.lineThrough,
    );
  }

  ///FontWeight W800
  static TextStyle kColorGreyW800(double fontSize) {
    return TextStyle(
      fontFamily: 'Manrope',
      fontSize: fontSize,
      fontWeight: FontWeight.w800,
      color: LightThemeColors.kColorGrey,
    );
  }
}


abstract class DarkThemeTextStyles {

  static TextStyle tabBarDarkStyleBlack(double fontSize) {
    return TextStyle(
      fontFamily: 'Manrope',
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    );
  }

  ///FontWeight W500
  static TextStyle kColorWhite2W500(double fontSize) {
    return TextStyle(
      fontFamily: 'Manrope',
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      color: DarkThemeColors.kColorWhite2,
    );
  }

  ///FontWeight W600
  static TextStyle kColorWhiteW600(double fontSize) {
    return TextStyle(
      fontFamily: 'Manrope',
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    );
  }

  ///FontWeight W800
  static TextStyle kColorWhite2W800(double fontSize) {
    return TextStyle(
      fontFamily: 'Manrope',
      fontSize: fontSize,
      fontWeight: FontWeight.w800,
      color: DarkThemeColors.kColorWhite2,
    );
  }

  static TextStyle kColorWhite2WithOpacityW500(double fontSize) {
    return TextStyle(
      fontFamily: 'Manrope',
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      color: DarkThemeColors.kColorWhite2.withOpacity(0.5),
    );
  }

  static TextStyle kColorWhiteWithOpacityW600(double fontSize) {
    return TextStyle(
      fontFamily: 'Manrope',
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      color: Colors.white.withOpacity(0.5),
      decoration: TextDecoration.lineThrough,
    );
  }
}