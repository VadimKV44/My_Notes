import 'package:hive/hive.dart';
import 'package:my_notes/Model/models/task_model/task_model.dart';

class TasksDataBase {
  static Box<TaskModel> tasksBox = Hive.box<TaskModel>('tasksBox');

  static Future<bool> openTaskBox() async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TaskModelAdapter());
    }
    tasksBox = await Hive.openBox('tasksBox');
    return tasksBox.isOpen;
  }

  static List<TaskModel> getAllTasks() {
    List<TaskModel> data = tasksBox.values.toList();
    return data;
  }

  static void saveNewTask(TaskModel task) async {
    await tasksBox.add(task);
  }

  static void overwriteTask(int index, TaskModel task) async {
    await tasksBox.putAt(index, task);
  }

  static TaskModel? getOneTask(int index) {
    TaskModel? data = tasksBox.getAt(index);
    return data;
  }

  static void deleteNote(int index) async {
    await tasksBox.deleteAt(index);
  }
}
