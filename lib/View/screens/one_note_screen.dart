import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_notes/Model/models/note_model/note_model.dart';
import 'package:my_notes/Presenter/cubits/notes_cubit/notes_cubit.dart';
import 'package:my_notes/View/consts/strings.dart';
import 'package:my_notes/View/widgets/custom_text_field_widget.dart';

class OneNoteScreen extends StatefulWidget {
  const OneNoteScreen({
    Key? key,
    this.note,
    required this.noteIndex,
    required this.save,
  }) : super(key: key);

  final NoteModel? note;
  final int noteIndex;
  final void Function(String text, DateTime createDate, int noteId) save;

  @override
  State<OneNoteScreen> createState() => _OneNoteScreenState();
}

class _OneNoteScreenState extends State<OneNoteScreen> {
  TextEditingController _controller = TextEditingController();
  DateTime? date;
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    autofocusTextField();
    _controller.text = widget.note?.text ?? '';
    date = widget.note?.createDate ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    NotesCubit notesCubit = BlocProvider.of<NotesCubit>(context);

    return WillPopScope(
      onWillPop: () async {
        _save(context, notesCubit);
        return false;
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            centerTitle: true,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  splashColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(20.0),
                  onTap: () => _save(context, notesCubit),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12.0, bottom: 12.0, left: 18.0, right: 8.0),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    DateFormat('dd MMMM yyyy', 'RU').format(date!).toString(),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(20.0),
                  onTap: () => _save(context, notesCubit),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Icon(
                      Icons.check,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 14.0, right: 14.0, top: 14.0, bottom: 60.0),
                        child: CustomTextFieldWidget(
                          focusNode: focusNode,
                          controller: _controller,
                          hintText: Strings.textOfNote,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _save(BuildContext context, NotesCubit notesCubit) {
    if (_controller.text.isNotEmpty) {
      if (widget.note == null) {
        widget.save(_controller.text, date!, widget.noteIndex);
      } else {
        if (widget.note?.text != _controller.text) {
          notesCubit.overwriteNote(widget.noteIndex, widget.noteIndex, _controller.text, date!);
        }
      }
    }
    _back();
  }

  void autofocusTextField() {
    Future.delayed(const Duration(milliseconds: 500), () {
      focusNode.requestFocus();
    });
  }

  void _back() {
    FocusScope.of(context).unfocus();
    Future.delayed(Duration(milliseconds: 200), () {
      Navigator.pop(context);
    });
  }
}