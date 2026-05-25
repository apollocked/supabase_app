import 'package:flutter/material.dart';
import 'package:my_supabase_app/logic/chat_provider.dart';
import 'package:provider/provider.dart';

class NewDMPage extends StatefulWidget {
  const NewDMPage({super.key});

  @override
  State<NewDMPage> createState() => _NewDMPageState();
}

class _NewDMPageState extends State<NewDMPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Message')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search users...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                context.read<ChatProvider>().searchUsersByUsername(value);
              },
            ),
          ),
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, _) {
                if (chatProvider.searchUsers.isEmpty) {
                  return const Center(child: Text('Search for users'));
                }
                return ListView.builder(
                  itemCount: chatProvider.searchUsers.length,
                  itemBuilder: (context, index) {
                    final user = chatProvider.searchUsers[index];
                    return ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.person)),
                      title: Text(user['username'] ?? 'Unknown'),
                      onTap: () async {
                        final groupId = await chatProvider.getOrCreateDM(
                          user['id'],
                        );
                        if (groupId != null && mounted) {
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context, groupId);
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
