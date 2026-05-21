import 'package:my_supabase_app/model/note.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NoteDatabase {
  final database = Supabase.instance.client.from('notes');

  Future<void> insertNote(Note note) async {
    await database.insert(note.toMap());
  }

  final stream = Supabase.instance.client
      .from('notes')
      .stream(primaryKey: ['id'])
      .map((data) => data.map((noteMap) => Note.fromMap(noteMap)).toList());

  Future<void> updateNote(Note note, String content) async {
    await database.update({'content': content}).eq('id', note.id!);
  }

  Future<void> deleteNote(Note note) async {
    await database.delete().eq('id', note.id);
  }
}
