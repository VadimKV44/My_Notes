import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:my_notes/Model/local_storage/databases/tasks_data_base.dart';
import 'package:my_notes/Model/models/task_model/task_model.dart';
import 'package:uuid/uuid.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskInitial());

  var uuid = Uuid();
  List<TaskModel> allTasks = [];
  List<TaskModel> notCompletedTasks = [];
  List<TaskModel> completedTasks = [];

  void getAllTasks() async {
    allTasks = TasksDataBase.getAllTasks();
    if (allTasks.isNotEmpty) {
      sortTasksByIsCompleted();
      notCompletedTasksIsEmpty = notCompletedTasks.isEmpty;
      completedTasksIsEmpty = completedTasks.isEmpty;
    }
    emit(TaskInitial());
  }

  void sortTasksByIsCompleted() {
    completedTasks = allTasks.where((element) => element.isCompleted).toList();
    sortTasksByCreationDate(completedTasks);
    notCompletedTasks = allTasks.where((element) => !element.isCompleted).toList();
    sortTasksByCreationDate(notCompletedTasks);
  }

  void sortTasksByCreationDate(List<TaskModel> data) {
    if (data.isNotEmpty) {
      data.sort((a, b) {
        return b.createDate!.compareTo(a.createDate!);
      });
      emit(TaskInitial());
    }
  }

  void saveTask(String text, DateTime createDate, int color, bool isCompleted, [String? taskKey]) async {
    String key = taskKey == null ? uuid.v1() : taskKey;
    TaskModel task = TaskModel(text: text, createDate: createDate, color: color, key: key, isCompleted: isCompleted);
    TasksDataBase.saveTask(key, task);
    if (taskKey == null) {
      notCompletedTasks.insert(0, task);
      await checkForEmptinessNotCompletedTasks();
    } else {
      if (task.isCompleted) {
        completedTasks[completedTasks.indexWhere((item) => item.key == taskKey)] = task;
        await checkForEmptinessCompletedTasks();
      } else {
        notCompletedTasks[notCompletedTasks.indexWhere((item) => item.key == taskKey)] = task;
        await checkForEmptinessNotCompletedTasks();
      }
    }
  }

  void removeTaskInList(TaskModel task) {
    if (task.isCompleted) {
      completedTasks.removeWhere((element) => element.key == task.key);
    } else {
      notCompletedTasks.removeWhere((element) => element.key == task.key);
    }
  }

  void overwritingTask(String text, DateTime createDate, int color, bool isCompleted, String taskKey) async {
    TaskModel newTask = TaskModel(text: text, createDate: createDate, color: color, key: taskKey, isCompleted: isCompleted);
    TasksDataBase.saveTask(taskKey, newTask);
    if (isCompleted) {
      completedTasks.add(newTask);
      sortTasksByCreationDate(completedTasks);
    } else {
      notCompletedTasks.add(newTask);
      sortTasksByCreationDate(notCompletedTasks);
    }
  }

  void deleteTask(TaskModel task) async {
    TasksDataBase.deleteTask(task);
    if (task.isCompleted) {
      completedTasks.removeWhere((element) => element.key == task.key);
    } else {
      notCompletedTasks.removeWhere((element) => element.key == task.key);
    }
    await checkForEmptinessCompletedTasks();
    await checkForEmptinessNotCompletedTasks();
  }

  TaskModel getOneTask(String key, [bool isCompleted = false]) {
    TaskModel? dat;
    if (isCompleted) {
      dat = completedTasks.firstWhere((element) => element.key == key);
    } else {
      dat = notCompletedTasks.firstWhere((element) => element.key == key);
    }
    return dat;
  }

  bool notCompletedTasksIsEmpty = true;

  Future<void> checkForEmptinessNotCompletedTasks() async {
    await Future.delayed(const Duration(milliseconds: 500), () {
      notCompletedTasksIsEmpty = notCompletedTasks.isEmpty;
    });
    emit(TaskInitial());
  }

  bool completedTasksIsEmpty = true;

  Future<void> checkForEmptinessCompletedTasks() async {
    await Future.delayed(const Duration(milliseconds: 500), () {
      completedTasksIsEmpty = completedTasks.isEmpty;
    });
    emit(TaskInitial());
  }
}
