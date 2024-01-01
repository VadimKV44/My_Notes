import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_notes/Model/local_storage/shared_preferences.dart';
import 'package:my_notes/Presenter/cubits/theme_cubit/theme_cubit.dart';
import 'package:my_notes/View/consts/colors.dart';
import 'package:my_notes/View/consts/strings.dart';
import 'dart:ui' as ui;

class SettingsBottomSheetWidget extends StatefulWidget {
  const SettingsBottomSheetWidget({Key? key}) : super(key: key);

  @override
  State<SettingsBottomSheetWidget> createState() => _SettingsBottomSheetWidgetState();
}

class _SettingsBottomSheetWidgetState extends State<SettingsBottomSheetWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return SizedBox(
          height: MediaQuery.of(context).size.height / 3,
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(
              sigmaX: 1.0,
              sigmaY: 1.0,
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.only(topRight: Radius.circular(20.0), topLeft: Radius.circular(20.0)),
              ),
              child: Column(
                children: [
                  Container(
                    height: 40.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
                    ),
                    child: Center(
                      child: Container(
                        height: 6.0,
                        width: 60.0,
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          Strings.decoration,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        const Expanded(child: SizedBox()),
                        InkWell(
                          onTap: () {
                            BlocProvider.of<ThemeCubit>(context).changeTheme(theme: 1);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: 30.0,
                            width: 30.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(width: 4, color: Settings.selectedTheme == 1 ? Colors.blueAccent : Colors.grey[400]!),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20.0),
                        InkWell(
                          onTap: () {
                            BlocProvider.of<ThemeCubit>(context).changeTheme(theme: 2);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: 30.0,
                            width: 30.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: DarkThemeColors.kPurple,
                              border: Border.all(width: 4, color: Settings.selectedTheme == 2 ? Colors.blueAccent : Colors.grey[400]!),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
