// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:my_supabase_app/model/note.dart';
import 'package:my_supabase_app/presentation/widgets/my_widgets/custom_confirmation.dart';
import 'package:my_supabase_app/presentation/widgets/my_widgets/custom_dialog.dart';
import 'package:my_supabase_app/service/note_database_service.dart';

class NoteHelperMethods {
  final noteDatabase = NoteDatabase();
  TextEditingController noteControler = TextEditingController();
  void updateNote(Note note, BuildContext context) {
    noteControler.text = note.content;
    customDialog(context, 'Update Note', noteControler, () async {
      await noteDatabase.updateNote(note, noteControler.text);
      noteControler.clear();
      Navigator.pop(context);
    });
  }

  void deleteNote(Note note, BuildContext context) {
    customConfirmationDialog(
      context,
      'Delete Note',
      'Are you sure you want to delete this note?',
      'Delete',
      () async {
        await noteDatabase.deleteNote(note);
        Navigator.pop(context);
      },
    );
  }

  Future<void> createNote(BuildContext context, String title) async {
    customDialog(context, title, noteControler, () async {
      final note = Note(content: noteControler.text);
      await noteDatabase.insertNote(note);
      noteControler.clear();
      Navigator.pop(context);
    });
  }
}
