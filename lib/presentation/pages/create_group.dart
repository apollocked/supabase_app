// lib/pages/create_group_page.dart
import 'package:flutter/material.dart';
import 'package:my_supabase_app/logic/chat_provider.dart';
import 'package:provider/provider.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final _groupNameController = TextEditingController();
  final _searchController = TextEditingController();
  final List<String> _selectedUserIds = [];
  final List<String> _selectedUsernames = [];

  @override
  void dispose() {
    _groupNameController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Group')),
      body: Column(
        children: [
          // Group Name
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _groupNameController,
              decoration: InputDecoration(
                hintText: 'Group name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // Selected Members Chips
          if (_selectedUsernames.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Wrap(
                spacing: 6,
                children: _selectedUsernames
                    .asMap()
                    .entries
                    .map(
                      (entry) => Chip(
                        label: Text(entry.value),
                        onDeleted: () {
                          setState(() {
                            _selectedUserIds.removeAt(entry.key);
                            _selectedUsernames.removeAt(entry.key);
                          });
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
          const SizedBox(height: 8),

          // Search Users
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Add members...',
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
          const SizedBox(height: 8),

          // Search Results
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, _) {
                return ListView.builder(
                  itemCount: chatProvider.searchUsers.length,
                  itemBuilder: (context, index) {
                    final user = chatProvider.searchUsers[index];
                    final userId = user['id'] as String;
                    final isSelected = _selectedUserIds.contains(userId);

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isSelected
                            ? Theme.of(context).primaryColor
                            : null,
                        child: const Icon(Icons.person),
                      ),
                      title: Text(user['username'] ?? 'Unknown'),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : null,
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            final idx = _selectedUserIds.indexOf(userId);
                            _selectedUserIds.removeAt(idx);
                            _selectedUsernames.removeAt(idx);
                          } else {
                            _selectedUserIds.add(userId);
                            _selectedUsernames.add(
                              user['username'] ?? 'Unknown',
                            );
                          }
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),

          // Create Button
          Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedUserIds.isEmpty ? null : _createGroup,
                child: const Text('Create Group'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _createGroup() async {
    final groupName = _groupNameController.text.trim();
    if (groupName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a group name')),
      );
      return;
    }

    final groupId = await context.read<ChatProvider>().createGroup(
      groupName,
      _selectedUserIds,
    );

    if (groupId != null && mounted) {
      Navigator.pop(context, groupId);
    }
  }
}
