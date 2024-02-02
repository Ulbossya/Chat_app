// chat_list_item.dart
import 'package:chat_app/utils.dart';
import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'package:provider/provider.dart';
import 'message_provider.dart';

class ChatListItem extends StatelessWidget {
  final String contactName;

  ChatListItem({required this.contactName});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: getAvatarBackgroundColor(contactName),
            child: Text(
              getInitials(contactName),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(
            contactName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15, 
            ),
          ),
          subtitle: Consumer<MessageProvider>(
            builder: (context, messageProvider, _) {
              String lastMessage = messageProvider.getLastMessage(contactName);
              return Text(
                lastMessage.isNotEmpty ? lastMessage : "Начните чат",
                style: TextStyle(
                  fontSize: 12, 
                ),
              );
            },
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(contactName: contactName),
              ),
            );
          },
        ),
        FractionallySizedBox(
          widthFactor: 0.9,
          child: Divider(),
        ),
      ],
    );
  }
}
