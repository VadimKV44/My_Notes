part of 'theme_cubit.dart';

@immutable
abstract class ThemeState {}

class ThemeInitial extends ThemeState {
  ThemeInitial({required this.selectedTheme});

  final ThemeData selectedTheme;
}
