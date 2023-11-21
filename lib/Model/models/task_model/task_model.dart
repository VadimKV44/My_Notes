import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 1)
class TaskModel {
  TaskModel({
    required this.id,
    required this.text,
    required this.createDate,
    this.isCompleted = false,
});

  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String? text;

  @HiveField(2)
  final DateTime? createDate;

  @HiveField(3)
  bool isCompleted;
}
