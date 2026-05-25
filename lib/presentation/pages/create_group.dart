import 'package:flutter/material.dart';
import 'package:my_supabase_app/logic/chat_provider.dart';
import 'package:my_supabase_app/presentation/widgets/custom_textfield.dart';
import 'package:my_supabase_app/presentation/widgets/search_users_result.dart';
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
          Padding(
            padding: const EdgeInsets.all(12),
            child: customTextField(
              _groupNameController,
              Icons.group,
              'Group name',
            ),
          ),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: customTextField(
              _searchController,
              Icons.search,
              'Add members...',
              onChanged: (value) {
                context.read<ChatProvider>().searchUsersByUsername(value);
              },
            ),
          ),
          const SizedBox(height: 8),
          SearchUsersResult(
            selectedUserIds: _selectedUserIds,
            selectedUsernames: _selectedUsernames,
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedUserIds.isNotEmpty ? _createGroup : null,
                child: const Text('Create Group'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
