import 'package:flutter/material.dart';
import 'package:my_supabase_app/logic/chat_provider.dart';
import 'package:provider/provider.dart';

void showGroupInfo(BuildContext context, String groupId) async {
  final members = await context.read<ChatProvider>().getGroupMembers(groupId);
  showModalBottomSheet(
    // ignore: use_build_context_synchronously
    context: context,
    builder: (_) => ListView(
      shrinkWrap: true,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Group Members',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ...members.map(
          (m) => ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(m['profiles']?['username'] ?? 'Unknown'),
          ),
        ),
      ],
    ),
  );
}
