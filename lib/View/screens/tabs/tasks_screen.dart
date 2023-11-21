import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_notes/Model/models/task_model/task_model.dart';
import 'package:my_notes/Presenter/cubits/task_cubit/task_cubit.dart';
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
  final GlobalKey<AnimatedListState> _listTaskKey = GlobalKey<AnimatedListState>(debugLabel: '_taskScreen');
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
              taskCubit.tasksIsEmpty
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
                      child: Column(
                        children: [
                          AnimatedList(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            reverse: true,
                            padding: const EdgeInsets.only(right: 24.0, left: 24.0, bottom: 20.0),
                            key: _listTaskKey,
                            initialItemCount: taskCubit.tasks.length,
                            itemBuilder: (context, index, animation) {
                              return SizeTransition(
                                sizeFactor: animation,
                                child: TaskItemWidget(
                                  task: taskCubit.tasks[index],
                                  deleteTask: () => _deleteTask(taskCubit, index),
                                  completeTask: () {
                                    if (!taskCubit.tasks[index].isCompleted) {
                                      TaskModel _deletedNote = taskCubit.getOneTask(index);
                                      taskCubit.completeTask(taskCubit.tasks[index].text!, index);
                                      AnimatedRemovedItemBuilder _builder = (context, animation) {
                                        return SizeTransition(
                                          sizeFactor: animation,
                                          child: TaskItemWidget(
                                            task: _deletedNote,
                                            taskIndex: index,
                                            deleteTask: () {},
                                            completeTask: () {},
                                          ),
                                        );
                                      };
                                      _listTaskKey.currentState?.removeItem(index, _builder);
                                    } else {
                                      _listTaskKey.currentState?.insertItem(taskCubit.tasks.isEmpty ? 0 : taskCubit.tasks.length);
                                      taskCubit.completeTask(taskCubit.tasks[index].text!, index);
                                    }

                                  },
                                  taskIndex: index,
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
                                        reverse: true,
                                        padding: const EdgeInsets.only(right: 24.0, left: 24.0, bottom: 80.0),
                                        key: _listCompletedTaskKey,
                                        initialItemCount: taskCubit.completedTasks.length,
                                        itemBuilder: (context, index, animation) {
                                          return SizeTransition(
                                            sizeFactor: animation,
                                            child: TaskItemWidget(
                                              task: taskCubit.completedTasks[index],
                                              deleteTask: () => _deleteTask(taskCubit, taskCubit.completedTasks[index].id!),//TODO index
                                              completeTask: () {
                                                if (taskCubit.completedTasks[index].isCompleted) {
                                                  TaskModel _deletedNote = taskCubit.getOneTask(index);
                                                  taskCubit.completeTask(taskCubit.completedTasks[index].text!, index);
                                                  AnimatedRemovedItemBuilder _builder = (context, animation) {
                                                    return SizeTransition(
                                                      sizeFactor: animation,
                                                      child: TaskItemWidget(
                                                        task: _deletedNote,
                                                        taskIndex: index,
                                                        deleteTask: () {},
                                                        completeTask: () {},
                                                      ),
                                                    );
                                                  };
                                                  _listTaskKey.currentState?.removeItem(index, _builder);
                                                } else {
                                                  _listTaskKey.currentState?.insertItem(taskCubit.completedTasks.isEmpty ? 0 : taskCubit.completedTasks.length);
                                                  taskCubit.completeTask(taskCubit.completedTasks[index].text!, index);
                                                }

                                              },
                                              taskIndex: index,
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
                      save: (String text, DateTime createDate, int taskId) {
                        _listTaskKey.currentState?.insertItem(taskCubit.tasksData.isEmpty ? 0 : taskCubit.tasksData.length);
                        taskCubit.saveNewTask(taskId, text, createDate);
                      },
                      taskIndex: taskCubit.tasksData.isEmpty ? taskCubit.tasksData.length : taskCubit.tasksData.length + 1,
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

  void _deleteTask(TaskCubit taskCubit, int index) {
    TaskModel _deletedNote = taskCubit.getOneTask(index);
    taskCubit.deleteTask(index);
    AnimatedRemovedItemBuilder _builder = (context, animation) {
      return SizeTransition(
        sizeFactor: animation,
        child: TaskItemWidget(
          task: _deletedNote,
          taskIndex: index,
          deleteTask: () {},
          completeTask: () {},
        ),
      );
    };

    _listTaskKey.currentState?.removeItem(index, _builder);
  }
}
