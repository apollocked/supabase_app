import 'package:flutter/material.dart';
import 'package:my_supabase_app/core/logic/client_provider.dart';
import 'package:my_supabase_app/model/note.dart';
import 'package:my_supabase_app/presentation/pages/chat_list_page.dart';
import 'package:my_supabase_app/presentation/pages/upload_page.dart';
import 'package:my_supabase_app/helpers/note_helper_methods.dart';
import 'package:my_supabase_app/presentation/widgets/custom_confirmation.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    NoteHelperMethods noteHelperMethods = NoteHelperMethods();
    Future<void> signOut(BuildContext context) async {
      context.read<ClientProvider>().signOut();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatListPage()),
              );
            },
            icon: const Icon(Icons.chat, size: 18),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UploadPage()),
              );
            },
            icon: const Icon(Icons.drive_folder_upload, size: 18),
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              customConfirmationDialog(
                context,
                "Logout",
                "Are you sure you want to logout",
                "Logout",
                () {
                  signOut(context);
                  Navigator.pop(context);
                },
              );
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
              stream: noteHelperMethods.noteDatabase.stream,
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
                                    noteHelperMethods.updateNote(note, context);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    noteHelperMethods.deleteNote(note, context);
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
          noteHelperMethods.createNote(context, 'New Note');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
