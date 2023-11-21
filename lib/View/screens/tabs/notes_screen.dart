import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_notes/Model/models/note_model/note_model.dart';
import 'package:my_notes/Presenter/cubits/notes_cubit/notes_cubit.dart';
import 'package:my_notes/View/screens/one_note_screen.dart';
import 'package:my_notes/View/widgets/custom_icon_button_widget.dart';
import 'package:my_notes/View/widgets/item_animation_widget.dart';
import 'package:my_notes/View/widgets/notes_item_widget.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  late AnimationController _animationController;
  final GlobalKey<AnimatedListState> _listNotesKey = GlobalKey<AnimatedListState>(debugLabel: '_notesScreen');

  @override
  void initState() {
    super.initState();
    BlocProvider.of<NotesCubit>(context).getAllNotes();
    _animationController = AnimationController(duration: const Duration(milliseconds: 80), vsync: this);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    NotesCubit notesCubit = BlocProvider.of<NotesCubit>(context);

    return BlocBuilder<NotesCubit, NotesState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Stack(
            children: [
              notesCubit.notesIsEmpty
                  ? FadeIn(
                      child: Center(
                        child: Icon(
                          Icons.edit_note,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 160.0,
                        ),
                      ),
                    )
                  : FadeInUp(
                      child: Column(
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: AnimatedList(
                                shrinkWrap: true,
                                reverse: true,
                                padding: const EdgeInsets.only(right: 24.0, left: 24.0, bottom: 80.0),
                                key: _listNotesKey,
                                initialItemCount: notesCubit.notes.length,
                                itemBuilder: (context, index, animation) {
                                  return SizeTransition(
                                    sizeFactor: animation,
                                    child: NotesItemWidget(
                                      note: notesCubit.notes[index],
                                      noteIndex: index,
                                      delete: () => _deleteNote(notesCubit, index),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
              Positioned(
                bottom: 20.0,
                right: 20.0,
                child: ItemAnimationWidget(
                  controller: _animationController,
                  openBuilder: (context, action) {
                    return OneNoteScreen(
                      noteIndex: notesCubit.notes.isEmpty ? notesCubit.notes.length : notesCubit.notes.length + 1,
                      save: (text, createDate, noteId) {
                        _listNotesKey.currentState?.insertItem(notesCubit.notes.isEmpty ? 0 : notesCubit.notes.length);
                        notesCubit.saveNewNote(noteId, text, createDate);
                      },
                    );
                  },
                  closedBuilder: (context, action) {
                    return CustomIconButtonWidget(
                      icon: Icons.edit_note,
                      onTap: action,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteNote(NotesCubit notesCubit, int index) {
    NoteModel _deletedNote = notesCubit.getOneNote(index);
    notesCubit.deleteNote(index);
    AnimatedRemovedItemBuilder _builder = (context, animation) {
      return SizeTransition(
        sizeFactor: animation,
        child: NotesItemWidget(
          note: _deletedNote,
          noteIndex: index,
          delete: () {},
        ),
      );
    };

    _listNotesKey.currentState?.removeItem(index, _builder);
  }
}
