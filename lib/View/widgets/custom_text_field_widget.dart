import 'package:flutter/material.dart';
import 'package:my_notes/View/consts/styles.dart';

class CustomTextFieldWidget extends StatelessWidget {
  const CustomTextFieldWidget({
    super.key,
    required this.controller,
    required this.hintText,
    required this.focusNode,
  });

  final TextEditingController controller;
  final String hintText;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      controller: controller,
      cursorColor: Theme.of(context).colorScheme.secondary,
      style: Theme.of(context).textTheme.bodyMedium,
      maxLines: null,
      minLines: null,
      enabled: true,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 2.0),
          borderRadius: BorderRadius.circular(14.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 2.0),
          borderRadius: BorderRadius.circular(14.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 2.0),
          borderRadius: BorderRadius.circular(14.0),
        ),
        hintText: hintText,
        helperStyle: LightThemeTextStyles.kColorGreyW800(16.0),
      ),
    );
  }
}
