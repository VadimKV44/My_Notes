import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/Model/local_storage/shared_preferences.dart';
import 'package:my_notes/View/theme_data/themes.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeInitial(selectedTheme: Themes.lightTheme()));

  int themeNumber = 1;

  void changeTheme({int theme = 1}) async {
    themeNumber = theme;
    ThemeData selectedTheme = Themes.lightTheme();

    if (theme == 1) {
      await Settings.setTheme(theme);
      selectedTheme = Themes.lightTheme();
      emit(ThemeInitial(selectedTheme: selectedTheme));
    } else {
      await Settings.setTheme(theme);
      selectedTheme = Themes.darkTheme();
      emit(ThemeInitial(selectedTheme: selectedTheme));
    }
  }

  void getSavedTheme() async {
    await Settings.getTheme();
    themeNumber = Settings.selectedTheme;
    if (Settings.selectedTheme == 1) {
      emit(ThemeInitial(selectedTheme: Themes.lightTheme()));
    } else {
      emit(ThemeInitial(selectedTheme: Themes.darkTheme()));
    }
  }
}
