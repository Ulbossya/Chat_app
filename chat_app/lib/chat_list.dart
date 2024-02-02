// chat_list.dart
import 'package:chat_app/chat_list_item.dart';
import 'package:flutter/material.dart';

class ChatList extends StatelessWidget {
  final List<String> contacts;

  ChatList({required this.contacts});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return ChatListItem(contactName: contacts[index]);
          
        },
      ),
    );
  }
}
