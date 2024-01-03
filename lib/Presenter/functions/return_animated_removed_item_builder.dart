import 'package:flutter/material.dart';
import 'package:my_notes/Model/models/note_model/note_model.dart';
import 'package:my_notes/Model/models/task_model/task_model.dart';
import 'package:my_notes/View/widgets/note_item_widget.dart';
import 'package:my_notes/View/widgets/task_item_widget.dart';

AnimatedRemovedItemBuilder returnAnimatedRemovedItemBuilder({NoteModel? note,TaskModel? task}) {
  return (context, animation) {
    return note == null ? SizeTransition(
      sizeFactor: animation,
      child: TaskItemWidget(
        task: task,
        deleteTask: () {},
        completeTask: () {},
      ),
    ) : SizeTransition(
      sizeFactor: animation,
      child: NoteItemWidget(
        note: note,
        delete: () {},
      ),
    );
  };
}