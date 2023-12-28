
import 'package:hive/hive.dart';
import 'package:my_notes/View/consts/hive_type_ids.dart';

part 'note_model.g.dart';

@HiveType(typeId: NoteModelHiveIds.hiveTypeId)
class NoteModel extends HiveObject {
  NoteModel({
    required this.text,
    required this.createDate,
    required this.key,
});

  @HiveField(NoteModelHiveIds.hiveFieldText)
  final String? text;

  @HiveField(NoteModelHiveIds.hiveFieldCreateDate)
  final DateTime? createDate;

  @HiveField(NoteModelHiveIds.hiveFieldKey)
  final String? key;
}
