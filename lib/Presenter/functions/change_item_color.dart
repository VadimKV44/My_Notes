import 'package:flutter/material.dart';
import 'package:my_notes/Presenter/cubits/theme_cubit/theme_cubit.dart';
import 'package:my_notes/View/consts/colors.dart';
import 'package:my_notes/View/theme_data/themes.dart';

Color changeItemColor(ThemeState state, int color) {
  Color result = Colors.blue;

  if (state is ThemeInitial) {
    if (state.selectedTheme == Themes.lightTheme()) {
      switch (color) {
        case 0:
          result = LightItemColors.kBlue;
        case 1:
          result = LightItemColors.kGreen;
        case 2:
          result = LightItemColors.kRed;
        case 3:
          result = LightItemColors.kYellow;
        default:
          result = LightItemColors.kBlue;
      }
    } else {
      switch (color) {
        case 0:
          result = DarkItemColors.kBlue;
        case 1:
          result = DarkItemColors.kGreen;
        case 2:
          result = DarkItemColors.kRed;
        case 3:
          result = DarkItemColors.kYellow;
        default:
          result = DarkItemColors.kBlue;
      }
    }
  }

  return result;
}