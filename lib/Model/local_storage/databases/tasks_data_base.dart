import 'package:hive/hive.dart';
import 'package:my_notes/Model/models/task_model/task_model.dart';

class TasksDataBase {
  static Box<TaskModel> tasksBox = Hive.box<TaskModel>('tasksBox');

  static Future<bool> openTaskBox() async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TaskModelAdapter());
    }
    tasksBox = await Hive.openBox('tasksBox');
    // Hive.deleteBoxFromDisk('tasksBox'); /// <- to clean the box when writing and reading errors occur
    return tasksBox.isOpen;
  }

  static List<TaskModel> getAllTasks() {
    List<TaskModel> data = tasksBox.values.toList();
    return data;
  }

  static void saveTask(String key, TaskModel task) async {
    await tasksBox.put(key, task);
  }

  static void deleteTask(TaskModel task) async {
    task.delete();
    await tasksBox.compact();
  }
}
