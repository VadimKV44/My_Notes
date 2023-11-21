import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:my_notes/Model/local_storage/databases/tasks_data_base.dart';
import 'package:my_notes/Model/models/task_model/task_model.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskInitial());

  List<TaskModel> tasksData = [];
  List<TaskModel> tasks = [];
  List<TaskModel> completedTasks = [];

  void getAllTasks() async {
    tasksData = TasksDataBase.getAllTasks();
    for (TaskModel item in tasksData) {
      if (!item.isCompleted) {
        tasks.add(item);
      } else {
        completedTasks.add(item);
      }
    }
    await checkForEmptinessTasks();
    emit(TaskInitial());
  }

  void saveNewTask(int taskId, String text, DateTime createDate) async {
    TaskModel task = TaskModel(id: taskId, text: text, createDate: createDate);
    TasksDataBase.saveNewTask(
      task,
    );

    tasks.clear();
    completedTasks.clear();
    getAllTasks();
    await checkForEmptinessTasks();
    emit(TaskInitial());
  }

  void overwriteTask(int index, int taskIndex, String text, DateTime createDate, [bool isCompleted = false]) {
    TaskModel task = TaskModel(id: taskIndex, text: text, createDate: createDate, isCompleted: isCompleted);
    TasksDataBase.overwriteTask(index, task);

    tasks.clear();
    completedTasks.clear();
    getAllTasks();
    emit(TaskInitial());
  }

  void deleteTask(int index) async {
    TasksDataBase.deleteNote(index);
    tasks.clear();
    completedTasks.clear();
    getAllTasks();
    await checkForEmptinessTasks();
    emit(TaskInitial());
  }

  TaskModel getOneTask(int index) {
    TaskModel data = TasksDataBase.getOneTask(index) ?? TaskModel(id: -1, text: '', createDate: DateTime.now());
    return data;
  }

  void completeTask(String text, int index) {
    for (TaskModel item in tasksData) {
      if (item.text == text) {
        item.isCompleted = !item.isCompleted;
        overwriteTask(index, item.id!, item.text!, item.createDate!, item.isCompleted);
      }
    }
    // tasks.clear();
    // completedTasks.clear();
    // getAllTasks();
    // emit(TaskInitial());
  }

  bool tasksIsEmpty = false;

  Future<void> checkForEmptinessTasks() async {
    await Future.delayed(const Duration(milliseconds: 500), () {
      tasksIsEmpty = tasks.isEmpty && completedTasks.isEmpty;
    });
  }
}
