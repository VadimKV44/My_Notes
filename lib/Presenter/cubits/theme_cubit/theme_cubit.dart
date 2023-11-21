import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/Model/local_storage/shared_preferences.dart';
import 'package:my_notes/View/theme_data/themes.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeInitial(selectedTheme: Themes.lightTheme()));

  void changedTheme({int themeNumber = 1}) async {
    ThemeData selectedTheme = Themes.lightTheme();

    if (themeNumber == 1) {
      await Settings.setTheme(themeNumber);
      selectedTheme = Themes.lightTheme();
      emit(ThemeInitial(selectedTheme: selectedTheme));
    } else {
      await Settings.setTheme(themeNumber);
      selectedTheme = Themes.darkTheme();
      emit(ThemeInitial(selectedTheme: selectedTheme));
    }
  }

  void gettingSavedTheme() async {
    await Settings.getTheme();
    if (Settings.selectedTheme == 1) {
      emit(ThemeInitial(selectedTheme: Themes.lightTheme()));
    } else {
      emit(ThemeInitial(selectedTheme: Themes.darkTheme()));
    }
  }
}
