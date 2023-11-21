import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_notes/Model/models/task_model/task_model.dart';
import 'package:my_notes/Presenter/cubits/task_cubit/task_cubit.dart';
import 'package:my_notes/View/consts/strings.dart';
import 'package:my_notes/View/widgets/custom_text_field_widget.dart';

class OneTaskScreen extends StatefulWidget {
  const OneTaskScreen({
    Key? key,
    this.task,
    required this.save,
    required this.taskIndex,
  }) : super(key: key);

  final TaskModel? task;
  final int taskIndex;
  final void Function(String text, DateTime createDate, int taskId) save;

  @override
  State<OneTaskScreen> createState() => _OneTaskScreenState();
}

class _OneTaskScreenState extends State<OneTaskScreen> {
  TextEditingController _controller = TextEditingController();
  final FocusNode focusNode = FocusNode();
  DateTime? date;

  @override
  void initState() {
    super.initState();
    autofocusTextField();
    _controller.text = widget.task?.text ?? '';
    date = widget.task?.createDate ?? DateTime.now();
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
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  splashColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(20.0),
                  onTap: () => _save(context, taskCubit),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12.0, bottom: 12.0, left: 18.0, right: 8.0),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                      DateFormat('dd MMMM yyyy', 'RU').format(date!).toString(),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(20.0),
                  onTap: () => _save(context, taskCubit),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Icon(Icons.check, color: Theme.of(context).iconTheme.color,),
                  ),
                ),
              ],
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 14.0, right: 14.0, top: 14.0, bottom: 60.0),
                        child: CustomTextFieldWidget(
                          focusNode: focusNode,
                          controller: _controller,
                          hintText: Strings.textOfTask,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _save(BuildContext context, TaskCubit taskCubit) {
    if (_controller.text.isNotEmpty) {
      if (widget.task == null) {
        widget.save(_controller.text, date!, widget.taskIndex);
      } else {
        if (widget.task?.text != _controller.text) {
          taskCubit.overwriteTask(widget.taskIndex, widget.taskIndex, _controller.text, date!);
        }
      }
    }
    _back();
  }


  void autofocusTextField() {
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
