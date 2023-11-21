
import 'package:hive/hive.dart';

part 'note_model.g.dart';

@HiveType(typeId: 0)
class NoteModel {
  NoteModel({
    required this.id,
    required this.text,
    required this.createDate,
});

  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String? text;

  @HiveField(2)
  final DateTime? createDate;
}
