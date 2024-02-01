import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatListScreen(),
    );
  }
}

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

  String getInitials(String name) {
    List<String> names = name.split(" ");
    String initials = "";
    for (var i = 0; i < names.length; i++) {
      initials += names[i][0].toUpperCase();
    }
    return initials;
  }

  Color getAvatarBackgroundColor(String contactName) {
    switch (contactName) {
      case 'Виктор Власов':
        return Color.fromRGBO(31, 219, 95, 1);
      case 'Саша Алексеев':
        return Color.fromRGBO(246, 103, 0, 1);
      case 'Пётр Жаринов':
        return Color.fromRGBO(0, 172, 246, 1);
      case 'Алина Жукова':
        return Color.fromRGBO(246, 103, 0, 1);
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Чаты',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: filterContacts,
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
          ),
         Divider(), 

          Expanded(
            child: ListView.builder(
              itemCount: displayedContacts.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            getAvatarBackgroundColor(displayedContacts[index]),
                        child: Text(
                          getInitials(displayedContacts[index]),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(displayedContacts[index]),
                      subtitle: Text('Last message...'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              contactName: displayedContacts[index],
                            ),
                          ),
                        );
                      },
                    ),
                    Divider(), // Add a divider after each contact
                  ],
                );
              },
            ),
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

class ChatScreen extends StatelessWidget {
  final String contactName;

  ChatScreen({required this.contactName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(contactName),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.grey[200],
              child: Center(
                child: Text('Chat messages will be displayed here'),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
