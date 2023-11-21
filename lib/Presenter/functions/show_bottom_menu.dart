import 'package:flutter/material.dart';

void showBottomSheetMenu({
  required BuildContext context,
  required Widget bottomSheetMenu,
}) {
  showModalBottomSheet(
    elevation: 0,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (builder) {
      return bottomSheetMenu;
    },
  );
}
