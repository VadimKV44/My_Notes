import 'package:hive/hive.dart';
import 'package:my_notes/View/consts/hive_type_ids.dart';

part 'task_model.g.dart';

@HiveType(typeId: TaskModelHiveIds.hiveTypeId)
class TaskModel extends HiveObject {
  TaskModel({
    required this.text,
    required this.createDate,
    this.isCompleted = false,
    required this.key,
    required this.color
});

  @HiveField(TaskModelHiveIds.hiveFieldText)
  final String? text;

  @HiveField(TaskModelHiveIds.hiveFieldCreateDate)
  final DateTime? createDate;

  @HiveField(TaskModelHiveIds.hiveFieldIsCompleted)
  bool isCompleted;

  @HiveField(TaskModelHiveIds.hiveFieldKey)
  String? key;

  @HiveField(TaskModelHiveIds.hiveFieldColor)
  int? color;
}
