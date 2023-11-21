import 'package:hive/hive.dart';
import 'package:my_notes/Model/models/note_model/note_model.dart';

class NotesDataBase {
  static Box<NoteModel> notesBox = Hive.box<NoteModel>('notesBox');

  static Future<bool> openNotesBox() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(NoteModelAdapter());
    }
    notesBox = await Hive.openBox('notesBox');
    return notesBox.isOpen;
  }

  static List<NoteModel> getAllNotes() {
    List<NoteModel> data = notesBox.values.toList();
    return data;
  }

  static void saveNewNote(NoteModel note) async {
    await notesBox.add(note);
  }

  static void overwriteNote(int index, NoteModel note) async {
    await notesBox.putAt(index, note);
  }

  static NoteModel? getOneNote(int index) {
    NoteModel? data = notesBox.getAt(index);
    return data;
  }

  static void deleteNote(int index) async {
    await notesBox.deleteAt(index);
  }
}
