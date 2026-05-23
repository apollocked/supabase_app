import 'package:flutter/material.dart';
import 'package:my_supabase_app/logic/client_provider.dart';
import 'package:my_supabase_app/model/note.dart';
import 'package:my_supabase_app/service/note_service.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    NoteService noteService = NoteService();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              signOut(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Wellcome ${Supabase.instance.client.auth.currentUser!.userMetadata?['username']} ",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(),
          Expanded(
            child: StreamBuilder<List<Note>>(
              stream: noteService.noteDatabase.stream,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Note>> snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (snapshot.hasData) {
                      final notes = snapshot.data ?? [];
                      if (notes.isEmpty) {
                        return const Center(child: Text('No notes yet!'));
                      }
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
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    noteService.updateNote(note, context);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    noteService.deleteNote(note, context);
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
          noteService.createNote(context, 'New Note');
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> signOut(BuildContext context) async {
    context.read<ClientProvider>().signOut();
  }
}
