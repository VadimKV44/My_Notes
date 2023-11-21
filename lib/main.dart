import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_notes/Presenter/cubits/notes_cubit/notes_cubit.dart';
import 'package:my_notes/Presenter/cubits/task_cubit/task_cubit.dart';
import 'package:my_notes/Presenter/cubits/theme_cubit/theme_cubit.dart';
import 'package:my_notes/View/screens/main_screen.dart';
import 'package:my_notes/View/theme_data/themes.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:io' show Platform;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (Platform.isAndroid) await FlutterDisplayMode.setHighRefreshRate();

  runApp(const MyApp());
}

//TODO записать в README то что я изучал и делал в этом приложении

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('ru');
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()..gettingSavedTheme()),
        BlocProvider<NotesCubit>(create: (context) => NotesCubit()),
        BlocProvider<TaskCubit>(create: (context) => TaskCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            theme: state is ThemeInitial ? state.selectedTheme : Themes.lightTheme(),
            home: const MainScreen(),
          );
        },
      ),
    );
  }
}
