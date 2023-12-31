import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_notes/Model/models/note_model/note_model.dart';
import 'package:my_notes/Presenter/cubits/theme_cubit/theme_cubit.dart';
import 'package:my_notes/Presenter/functions/change_item_color.dart';
import 'package:my_notes/View/screens/one_note_screen.dart';
import 'package:my_notes/View/widgets/item_animation_widget.dart';
import 'package:my_notes/View/widgets/note_item_up_panel_widget.dart';

class NoteItemWidget extends StatefulWidget {
  const NoteItemWidget({
    Key? key,
    required this.delete,
    required this.note,
  }) : super(key: key);

  final Function() delete;
  final NoteModel note;

  @override
  State<NoteItemWidget> createState() => _NoteItemWidgetState();
}

class _NoteItemWidgetState extends State<NoteItemWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 80),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: ItemAnimationWidget(
        controller: _animationController,
        openBuilder: (context, action) {
          return OneNoteScreen(note: widget.note);
        },
        closedBuilder: (context, action) {
          return InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            borderRadius: BorderRadius.circular(20.0),
            onTap: () => _openOneNoteScreen(action),
            child: BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, state) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: changeItemColor(state, widget.note.color ?? 0).withOpacity(0.2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NoteItemUpPanelWidget(
                        createDate: widget.note.createDate!,
                        deleteNote: widget.delete,
                        color: widget.note.color ?? 0,
                      ),
                      LimitedBox(
                        maxHeight: 200.0,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 20.0, bottom: 20.0, right: 20.0),
                          child: Text(
                            widget.note.text ?? '',
                            style: Theme.of(context).textTheme.bodyMedium,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _openOneNoteScreen(void Function() action) {
    _animationController.forward();
    Future.delayed(const Duration(milliseconds: 80), () {
      action();
      _animationController.reverse();
    });
  }
}
