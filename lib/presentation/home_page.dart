import 'package:flutter/material.dart';
import 'package:supabase/model/note.dart';
import 'package:supabase/service/note_database.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final noteDatabase = NoteDatabase();

  final noteControler = TextEditingController();

  //methods
  updateNote(Note note) {
    noteDatabase.updateNote(note, noteControler.text);
  }

  deleteNoe(Note note) {
    noteDatabase.deleteNote(note);
  }

  createNote() async {
    final note = Note(content: noteControler.text);
    await noteDatabase.insertNote(note);
    noteControler.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: noteControler,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter a note',
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {},
        child: Icon(Icons.add),
      ),
    );
  }
}
