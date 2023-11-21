import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class NoteItemUpPanelWidget extends StatelessWidget {
  const NoteItemUpPanelWidget({
    super.key,
    required this.createDate,
    required this.deleteNote,
  });

  final DateTime createDate;
  final void Function() deleteNote;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              DateFormat('dd.MM.yyyy').format(createDate).toString(),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          GestureDetector(
            onTap: deleteNote,
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0, bottom: 10.0),
              child: SvgPicture.asset(
                'assets/icons/delete.svg',
                color: Theme.of(context).iconTheme.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
