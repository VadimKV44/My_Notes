import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class TaskItemUpPanelWidget extends StatelessWidget {
  const TaskItemUpPanelWidget({
    super.key,
    required this.isCompleted,
    required this.completeTask,
    required this.deleteTask,
    required this.date,
  });

  final bool isCompleted;
  final void Function() completeTask;
  final void Function() deleteTask;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: completeTask,
          child: isCompleted
              ? Icon(
                  Icons.check_circle_outline,
                  color: Theme.of(context).colorScheme.tertiary,
                )
              : const Icon(Icons.radio_button_unchecked),
        ),
        Text(
          DateFormat('dd.MM.yyyy').format(date).toString(),
          style: isCompleted ? Theme.of(context).textTheme.labelLarge : Theme.of(context).textTheme.headlineSmall,
        ),
        InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: deleteTask,
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: SvgPicture.asset(
              'assets/icons/delete.svg',
              color: isCompleted ? Theme.of(context).colorScheme.tertiary : Theme.of(context).iconTheme.color,
            ),
          ),
        ),
      ],
    );
  }
}
