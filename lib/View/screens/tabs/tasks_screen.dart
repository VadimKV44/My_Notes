import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_notes/Model/models/task_model/task_model.dart';
import 'package:my_notes/Presenter/cubits/task_cubit/task_cubit.dart';
import 'package:my_notes/Presenter/functions/return_animated_removed_item_builder.dart';
import 'package:my_notes/View/consts/strings.dart';
import 'package:my_notes/View/consts/styles.dart';
import 'package:my_notes/View/screens/one_task_screen.dart';
import 'package:my_notes/View/widgets/custom_icon_button_widget.dart';
import 'package:my_notes/View/widgets/item_animation_widget.dart';
import 'package:my_notes/View/widgets/task_item_widget.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  late AnimationController _animationController;
  final GlobalKey<AnimatedListState> _listNotCompletedTaskKey = GlobalKey<AnimatedListState>(debugLabel: '_taskScreen');
  final GlobalKey<AnimatedListState> _listCompletedTaskKey = GlobalKey<AnimatedListState>(debugLabel: '_taskCompletedScreen');

  @override
  void initState() {
    super.initState();
    BlocProvider.of<TaskCubit>(context).getAllTasks();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 80),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    TaskCubit taskCubit = BlocProvider.of<TaskCubit>(context);

    return BlocBuilder<TaskCubit, TaskState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Stack(
            children: [
              taskCubit.notCompletedTasksIsEmpty && taskCubit.completedTasksIsEmpty
                  ? FadeIn(
                      child: Center(
                        child: Icon(
                          Icons.task,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 160.0,
                        ),
                      ),
                    )
                  : FadeInUp(
                      child: ListView(
                        children: [
                          AnimatedList(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(right: 24.0, left: 24.0, bottom: 20.0),
                            key: _listNotCompletedTaskKey,
                            initialItemCount: taskCubit.notCompletedTasks.length,
                            itemBuilder: (context, index, animation) {
                              return SizeTransition(
                                sizeFactor: animation,
                                child: TaskItemWidget(
                                  task: taskCubit.notCompletedTasks[index],
                                  deleteTask: () => _deleteTask(taskCubit, index, taskCubit.notCompletedTasks[index]),
                                  completeTask: () => _completeTask(taskCubit, taskCubit.notCompletedTasks[index], index),
                                ),
                              );
                            },
                          ),
                          taskCubit.completedTasks.isEmpty
                              ? const SizedBox()
                              : FadeInUp(
                                  child: Column(
                                    children: [
                                      Text(
                                        Strings.completed,
                                        textAlign: TextAlign.center,
                                        style: LightThemeTextStyles.kColorGreyW600(20.0),
                                      ),
                                      AnimatedList(
                                        physics: const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        padding: const EdgeInsets.only(right: 24.0, left: 24.0, bottom: 80.0),
                                        key: _listCompletedTaskKey,
                                        initialItemCount: taskCubit.completedTasks.length,
                                        itemBuilder: (context, index, animation) {
                                          return SizeTransition(
                                            sizeFactor: animation,
                                            child: TaskItemWidget(
                                              task: taskCubit.completedTasks[index],
                                              deleteTask: () => _deleteTask(taskCubit, index, taskCubit.completedTasks[index]),
                                              completeTask: () => _completeTask(taskCubit, taskCubit.completedTasks[index], index),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                    ),
              Positioned(
                bottom: 20.0,
                right: 20.0,
                child: ItemAnimationWidget(
                  controller: _animationController,
                  openBuilder: (context, action) {
                    return OneTaskScreen(
                      saveTask: (String text, DateTime createDate, int taskColor) => _saveTask(taskCubit, text, createDate, taskColor),
                    );
                  },
                  closedBuilder: (context, action) {
                    return CustomIconButtonWidget(
                      iconSize: 30.0,
                      topPadding: 12.0,
                      bottomPadding: 12.0,
                      leftPadding: 12.0,
                      rightPadding: 12.0,
                      icon: Icons.task,
                      onTap: () {
                        action();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteTask(TaskCubit taskCubit, int index, TaskModel task) {
    TaskModel _deletedTask = taskCubit.getOneTask(task.key!, task.isCompleted);
    taskCubit.deleteTask(task);
    if (task.isCompleted) {
      _listCompletedTaskKey.currentState?.removeItem(index, returnAnimatedRemovedItemBuilder(task: _deletedTask));
    } else {
      _listNotCompletedTaskKey.currentState?.removeItem(index, returnAnimatedRemovedItemBuilder(task: _deletedTask));
    }
  }

  void _saveTask(TaskCubit taskCubit, String text, DateTime createDate, int taskColor) {
    _listNotCompletedTaskKey.currentState?.insertItem(taskCubit.notCompletedTasks.isEmpty ? 0 : taskCubit.notCompletedTasks.length);
    taskCubit.saveTask(text, createDate, taskColor, false);
  }

  void _completeTask(TaskCubit taskCubit, TaskModel task, int index) {
    TaskModel _deletedTask = taskCubit.getOneTask(task.key!, task.isCompleted);
    if (task.isCompleted) {
      taskCubit.removeTaskInList(task);
      _listCompletedTaskKey.currentState?.removeItem(index, returnAnimatedRemovedItemBuilder(task: _deletedTask));
      _listNotCompletedTaskKey.currentState?.insertItem(taskCubit.notCompletedTasks.isEmpty ? 0 : taskCubit.notCompletedTasks.length );
      taskCubit.overwritingTask(task.text!, task.createDate!, task.color!, false, task.key!);
    } else {
      taskCubit.removeTaskInList(task);
      _listNotCompletedTaskKey.currentState?.removeItem(index, returnAnimatedRemovedItemBuilder(task: _deletedTask));
      _listCompletedTaskKey.currentState?.insertItem(taskCubit.completedTasks.isEmpty ? 0 : taskCubit.completedTasks.length );
      taskCubit.overwritingTask(task.text!, task.createDate!, task.color!, true, task.key!);
    }
  }
}
