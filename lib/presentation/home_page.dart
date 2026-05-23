import 'package:flutter/material.dart';
import 'package:my_supabase_app/logic/client_provider.dart';
import 'package:my_supabase_app/model/note.dart';
import 'package:my_supabase_app/service/note_database.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final noteDatabase = NoteDatabase();
  final noteControler = TextEditingController();
  final supabase = Supabase.instance.client;

  //methods
  void updateNote(Note note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Note'),
        content: TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter a note',
          ),
          controller: noteControler,
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Save'),
            onPressed: () async {
              await noteDatabase.updateNote(note, noteControler.text);
              noteControler.clear();
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void deleteNoe(Note note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Note'),
        content: Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Delete', style: TextStyle(color: Colors.red)),
            onPressed: () async {
              await noteDatabase.deleteNote(note);
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> createNote() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Create Note'),
        content: TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter a note',
          ),
          controller: noteControler,
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Save'),
            onPressed: () async {
              final note = Note(content: noteControler.text);
              await noteDatabase.insertNote(note);
              noteControler.clear();
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> signOut() async {
    context.read<ClientProvider>().signOut();
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              signOut();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Wellcome ${supabase.auth.currentUser!.userMetadata?['username']} ",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(),

          Expanded(
            child: StreamBuilder(
              stream: noteDatabase.stream,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  final notes = snapshot.data as List<Note>;
                  return ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      return ListTile(
                        title: Text(note.content),

                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                noteControler.text = note.content;
                                updateNote(note);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                deleteNoe(note);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createNote();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
