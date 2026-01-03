import 'package:fennac_app/pages/chats/presentation/widgets/call_history_item.dart';
import 'package:flutter/material.dart';

class GroupListItem extends StatelessWidget {
  final List<String> names;
  final String lastMessage;
  final String time;
  final List<String> avatars;

  const GroupListItem({
    super.key,
    required this.names,
    required this.lastMessage,
    required this.time,
    required this.avatars,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: CallHistoryItem(
        names: names,
        lastMessage: lastMessage,
        timeAgo: time,
        avatars: avatars,
        isGroup: true,
      ),
    );
  }
}
