import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_notes/Model/models/task_model/task_model.dart';
import 'package:my_notes/Presenter/cubits/theme_cubit/theme_cubit.dart';
import 'package:my_notes/Presenter/functions/change_item_color.dart';
import 'package:my_notes/View/screens/one_task_screen.dart';
import 'package:my_notes/View/widgets/item_animation_widget.dart';
import 'package:my_notes/View/widgets/task_item_up_panel_widget.dart';

class TaskItemWidget extends StatefulWidget {
  const TaskItemWidget({
    Key? key,
    required this.deleteTask,
    required this.completeTask,
    this.task,
  }) : super(key: key);

  final Function() deleteTask;
  final Function() completeTask;
  final TaskModel? task;

  @override
  State<TaskItemWidget> createState() => _TaskItemWidgetState();
}

class _TaskItemWidgetState extends State<TaskItemWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 80),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: ItemAnimationWidget(
        controller: _animationController,
        openBuilder: (context, action) {
          return OneTaskScreen(task: widget.task);
        },
        closedBuilder: (context, action) {
          return InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            borderRadius: BorderRadius.circular(20.0),
            onTap: () => _openOneTaskScreen(action),
            child: BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, state) {
                return Opacity(
                  opacity: widget.task!.isCompleted ? 0.5 : 1.0,
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: changeItemColor(state, widget.task?.color ?? 0)),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0, left: 10.0, top: 10.0),
                          child: TaskItemUpPanelWidget(
                            date: widget.task!.createDate!,
                            isCompleted: widget.task!.isCompleted,
                            completeTask: () {
                              _animationController.forward();
                              Future.delayed(const Duration(milliseconds: 80), () {
                                widget.completeTask();
                                _animationController.reverse();
                              });
                            },
                            deleteTask: widget.deleteTask,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 24.0),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(20.0),
                            ),
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(20.0),
                              ),
                              color: changeItemColor(state, widget.task?.color ?? 0).withOpacity(0.1),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 6.0, left: 10.0, bottom: 6.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.task!.text ?? '',
                                      style:
                                          widget.task!.isCompleted ? Theme.of(context).textTheme.labelMedium : Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _openOneTaskScreen(void Function() action) {
    _animationController.forward();
    Future.delayed(const Duration(milliseconds: 80), () {
      action();
      _animationController.reverse();
    });
  }
}
