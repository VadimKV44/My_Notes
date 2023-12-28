import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:my_notes/Model/local_storage/databases/notes_data_base.dart';
import 'package:my_notes/Model/models/note_model/note_model.dart';

part 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  NotesCubit() : super(NotesInitial());

  List<NoteModel> notes = [];

  void getAllNotes() async {
    notes = NotesDataBase.getAllNotes();
    await checkForEmptinessNotes();
    emit(NotesInitial());
  }

  void saveNewNote(int noteId, String text, DateTime createDate) async {
    NoteModel note = NoteModel(id: noteId, text: text, createDate: createDate);
    NotesDataBase.saveNewNote(
      note,
    );
    notes.clear();
    getAllNotes();
    await checkForEmptinessNotes();
    emit(NotesInitial());
  }

  void overwriteNote(int noteIndex, String text, DateTime createDate) {
    NoteModel note = NoteModel(id: noteIndex, text: text, createDate: createDate);
    NotesDataBase.overwriteNote(noteIndex, note);
    notes.clear();
    getAllNotes();
    emit(NotesInitial());
  }

  void deleteNote(int index) async {
    NotesDataBase.deleteNote(index);
    notes.clear();
    getAllNotes();
    await checkForEmptinessNotes();
    emit(NotesInitial());
  }

  NoteModel getOneNote(int index) {
    NoteModel data = NotesDataBase.getOneNote(index) ?? NoteModel(id: -1, text: '', createDate: DateTime.now());
    return data;
  }

  bool notesIsEmpty = false;

  Future<void> checkForEmptinessNotes() async {
    await Future.delayed(const Duration(milliseconds: 500), () {
      notesIsEmpty = notes.isEmpty;
    });
  }
}
