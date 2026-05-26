import 'package:flutter/material.dart';
import 'package:my_supabase_app/core/logic/chat_provider.dart';
import 'package:provider/provider.dart';

class SearchUsersResult extends StatefulWidget {
  const SearchUsersResult({
    super.key,
    required this.selectedUserIds,
    required this.selectedUsernames,
  });
  final List<String> selectedUserIds;
  final List<String> selectedUsernames;
  @override
  State<SearchUsersResult> createState() => _SearchUsersResultState();
}

class _SearchUsersResultState extends State<SearchUsersResult> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<ChatProvider>(
        builder: (context, chatProvider, _) {
          return ListView.builder(
            itemCount: chatProvider.searchUsers.length,
            itemBuilder: (context, index) {
              final user = chatProvider.searchUsers[index];
              final userId = user['id'] as String;
              final isSelected = widget.selectedUserIds.contains(userId);
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
                      final idx = widget.selectedUserIds.indexOf(userId);
                      widget.selectedUserIds.removeAt(idx);
                      widget.selectedUsernames.removeAt(idx);
                    } else {
                      widget.selectedUserIds.add(userId);
                      widget.selectedUsernames.add(
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
    );
  }
}
