import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_notes/Model/models/task_model/task_model.dart';
import 'package:my_notes/Presenter/cubits/task_cubit/task_cubit.dart';
import 'package:my_notes/Presenter/cubits/theme_cubit/theme_cubit.dart';
import 'package:my_notes/Presenter/functions/change_item_color.dart';
import 'package:my_notes/View/consts/strings.dart';
import 'package:my_notes/View/widgets/color_item_widget.dart';
import 'package:my_notes/View/widgets/custom_app_bar_widget.dart';
import 'package:my_notes/View/widgets/custom_text_field_widget.dart';

class OneTaskScreen extends StatefulWidget {
  const OneTaskScreen({
    Key? key,
    this.task,
    this.saveTask,
  }) : super(key: key);

  final TaskModel? task;
  final void Function(String text, DateTime createDate, int taskColor)? saveTask;

  @override
  State<OneTaskScreen> createState() => _OneTaskScreenState();
}

class _OneTaskScreenState extends State<OneTaskScreen> {
  TextEditingController _controller = TextEditingController();
  final FocusNode focusNode = FocusNode();
  DateTime? date;
  bool isCompleted = false;
  int taskColor = 0;
  /// noteColor = 0 - blue
  /// noteColor = 1 - green
  /// noteColor = 0 - red
  /// noteColor = 0 - yellow

  @override
  void initState() {
    super.initState();
    initialization();
  }

  @override
  Widget build(BuildContext context) {
    TaskCubit taskCubit = BlocProvider.of<TaskCubit>(context);

    return WillPopScope(
      onWillPop: () async {
        _save(context, taskCubit);
        return false;
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              appBar: CustomAppBarWidget(
                onTap: () => _save(context, taskCubit),
                date: DateFormat('dd MMMM yyyy', 'RU').format(date!).toString(),
                color: changeItemColor(state, taskColor),
              ),
              body: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                color: changeItemColor(state, taskColor).withOpacity(0.2),
                child: SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 14.0, right: 14.0, top: 14.0, bottom: 60.0),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: changeItemColor(state, taskColor), width: 2.0),
                                  borderRadius: BorderRadius.circular(14.0),
                                ),
                                child: CustomTextFieldWidget(
                                  focusNode: focusNode,
                                  controller: _controller,
                                  hintText: Strings.textOfTask,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: SizedBox(
                          height: 30.0,
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: 4,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  left: index == 0 ? 0.0 : 5.0,
                                  right: 5.0,
                                ),
                                child: ColorItemWidget(
                                  onTap: () => _selectColor(index),
                                  color: changeItemColor(state, index),
                                  isSelected: taskColor == index,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void initialization() {
    _autofocusTextField();
    _controller.text = widget.task?.text ?? '';
    date = widget.task?.createDate ?? DateTime.now();
    taskColor = widget.task?.color ?? 0;
    isCompleted = widget.task?.isCompleted ?? false;
  }

  void _selectColor(int index) {
    setState(() {
      taskColor = index;
    });
  }

  void _save(BuildContext context, TaskCubit taskCubit) {
    if (_controller.text.isNotEmpty) {
      if (widget.task == null) {
        widget.saveTask!(_controller.text, date!, taskColor);
      } else {
        if (widget.task?.text != _controller.text || widget.task?.color != taskColor) {
          taskCubit.saveTask(_controller.text, date!, taskColor, isCompleted, widget.task?.key ?? null);
        }
      }
    }
    _back();
  }

  void _autofocusTextField() {
    Future.delayed(const Duration(milliseconds: 500), () {
      focusNode.requestFocus();
    });
  }

  void _back() {
    FocusScope.of(context).unfocus();
    Future.delayed(Duration(milliseconds: 200), () {
      Navigator.pop(context);
    });
  }
}
