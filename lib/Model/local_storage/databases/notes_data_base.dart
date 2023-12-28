import 'package:hive/hive.dart';
import 'package:my_notes/Model/models/note_model/note_model.dart';

class NotesDataBase {
  static Box<NoteModel> notesBox = Hive.box<NoteModel>('notesBox');

  static Future<bool> openNotesBox() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(NoteModelAdapter());
    }
    notesBox = await Hive.openBox('notesBox');
    // Hive.deleteBoxFromDisk('notesBox'); /// <- to clean the box when writing and reading errors occur
    return notesBox.isOpen;
  }

  static List<NoteModel> getAllNotes() {
    List<NoteModel> data = notesBox.values.toList();
    return data;
  }

  static void saveNote(String key, NoteModel note) async {
    await notesBox.put(key, note);
  }

  static void deleteNote(NoteModel note) async {
    note.delete();
    await notesBox.compact();
  }
}
