import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:my_notes/Model/local_storage/databases/notes_data_base.dart';
import 'package:my_notes/Model/models/note_model/note_model.dart';
import 'package:uuid/uuid.dart';

part 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  NotesCubit() : super(NotesInitial());

  var uuid = Uuid();
  List<NoteModel> notes = [];

  void getAllNotes() async {
    notes = NotesDataBase.getAllNotes();
    await checkForEmptinessNotes();
    sortNotesByCreationDate();
    emit(NotesInitial());
  }

  void saveNote(String text, DateTime createDate, [String? noteKey]) async {
    String key = noteKey == null ? uuid.v1() : noteKey;
    NoteModel note = NoteModel(text: text, createDate: createDate, key: key);
    NotesDataBase.saveNote(key, note);
    noteKey == null ? notes.insert(0, note) : notes[notes.indexWhere((item) => item.key == noteKey)] = note;
    await checkForEmptinessNotes();
    emit(NotesInitial());
  }

  void deleteNote(NoteModel note) async {
    NotesDataBase.deleteNote(note);
    notes.removeWhere((element) => element.key == note.key);
    await checkForEmptinessNotes();
    emit(NotesInitial());
  }

  NoteModel getOneNote(String key) {
    NoteModel? dat;
    dat = notes.firstWhere((element) => element.key == key);
    return dat;
  }

  void sortNotesByCreationDate() {
    notes.sort((a, b) {
      return b.createDate!.compareTo(a.createDate!);
    });
  }

  bool notesIsEmpty = false;

  Future<void> checkForEmptinessNotes() async {
    await Future.delayed(const Duration(milliseconds: 500), () {
      notesIsEmpty = notes.isEmpty;
    });
  }
}
