//chat_list_screen
import 'package:flutter/material.dart';
import 'chat_list.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}
class _ChatListScreenState extends State<ChatListScreen> {
  List<String> contacts = [
    'Виктор Власов',
    'Саша Алексеев',
    'Пётр Жаринов',
    'Алина Жукова',
  ];
  List<String> displayedContacts = [];

  @override
  void initState() {
    super.initState();
    displayedContacts = List.from(contacts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Чаты',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 32,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity, 
            child: Column(
              children: [
                SearchBar(onFilter: filterContacts),
                        Divider(),
              ],
            ),
          ),
          Expanded(
            child: ChatList(contacts: displayedContacts),
          ),
        ],
      ),
    );
  }

  void filterContacts(String query) {
    setState(() {
      displayedContacts = contacts
          .where((contact) =>
              contact.toLowerCase().contains(query.toLowerCase()))
          .toList();
      displayedContacts = displayedContacts.take(4).toList();
    });
  }
}

class SearchBar extends StatelessWidget {
  final Function(String) onFilter;

  SearchBar({required this.onFilter});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        onChanged: onFilter,
        style: TextStyle(color: Color.fromRGBO(157, 183, 203, 1)),
        decoration: InputDecoration(
          hintText: 'Поиск...',
          hintStyle: TextStyle(color: Color.fromRGBO(157, 183, 203, 1)),
          prefixIcon: Icon(
            Icons.search,
            color: Color.fromRGBO(157, 183, 203, 1),
          ),
          fillColor: Color.fromRGBO(237, 242, 246, 1),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
