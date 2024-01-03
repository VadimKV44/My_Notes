import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_notes/Model/models/note_model/note_model.dart';
import 'package:my_notes/Presenter/cubits/notes_cubit/notes_cubit.dart';
import 'package:my_notes/Presenter/cubits/theme_cubit/theme_cubit.dart';
import 'package:my_notes/Presenter/functions/change_item_color.dart';
import 'package:my_notes/View/consts/strings.dart';
import 'package:my_notes/View/widgets/color_item_widget.dart';
import 'package:my_notes/View/widgets/custom_app_bar_widget.dart';
import 'package:my_notes/View/widgets/custom_text_field_widget.dart';

class OneNoteScreen extends StatefulWidget {
  const OneNoteScreen({
    Key? key,
    this.note,
    this.saveNote,
  }) : super(key: key);

  final NoteModel? note;
  final void Function(String text, DateTime createDate, int color)? saveNote;

  @override
  State<OneNoteScreen> createState() => _OneNoteScreenState();
}

class _OneNoteScreenState extends State<OneNoteScreen> {
  TextEditingController _controller = TextEditingController();
  DateTime? date;
  final FocusNode focusNode = FocusNode();
  int noteColor = 0;
  /// noteColor = 0 - blue
  /// noteColor = 1 - green
  /// noteColor = 0 - red
  /// noteColor = 0 - yellow

  @override
  void initState() {
    super.initState();
    initialization();
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
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              appBar: CustomAppBarWidget(
                onTap: () => _save(context, notesCubit),
                date: DateFormat('dd MMMM yyyy', 'RU').format(date!).toString(),
                color: changeItemColor(state, noteColor),
              ),
              body: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                color: changeItemColor(state, noteColor).withOpacity(0.2),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 14.0, right: 14.0, top: 14.0, bottom: 60.0),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: changeItemColor(state, noteColor), width: 2.0),
                                  borderRadius: BorderRadius.circular(14.0),
                                ),
                                child: CustomTextFieldWidget(
                                  focusNode: focusNode,
                                  controller: _controller,
                                  hintText: Strings.textOfNote,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: SizedBox(
                          height: 30.0,
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: 4,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  left: index == 0 ? 0.0 : 5.0,
                                  right: 5.0,
                                ),
                                child: ColorItemWidget(
                                  onTap: () => _selectColor(index),
                                  color: changeItemColor(state, index),
                                  isSelected: noteColor == index,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void initialization() {
    _autofocusTextField();
    _controller.text = widget.note?.text ?? '';
    date = widget.note?.createDate ?? DateTime.now();
    noteColor = widget.note?.color ?? 0;
  }

  void _selectColor(int index) {
    setState(() {
      noteColor = index;
    });
  }

  void _save(BuildContext context, NotesCubit notesCubit) {
    if (_controller.text.isNotEmpty) {
      if (widget.note == null) {
        widget.saveNote!(_controller.text, date!, noteColor);
      } else {
        if (widget.note?.text != _controller.text || widget.note?.color != noteColor) {
          notesCubit.saveNote(_controller.text, date!, noteColor, widget.note?.key ?? null);
        }
      }
    }
    _back();
  }

  void _autofocusTextField() {
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
