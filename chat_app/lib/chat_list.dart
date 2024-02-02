//chat_list.dart
import 'package:chat_app/chat_screen.dart';
import 'package:chat_app/utils.dart';
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
          return Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: getAvatarBackgroundColor(contacts[index]),
                  child: Text(
                    getInitials(contacts[index]),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  contacts[index],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0, 
                  ),
                ),
                subtitle: Text('Last message...'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(contactName: contacts[index]),
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
        },
      ),
    );
  }
}

