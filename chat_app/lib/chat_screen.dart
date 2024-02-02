import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'message_provider.dart';
import 'utils.dart';

class ChatScreen extends StatefulWidget {
  final String contactName;

  ChatScreen({required this.contactName});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.0),
              child: CircleAvatar(
                backgroundColor: getAvatarBackgroundColor(widget.contactName),
                child: Text(
                  getInitials(widget.contactName),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                radius: 20.0,
              ),
            ),
            SizedBox(width: 4.0), 
            Text(widget.contactName),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.grey[200],
              child: Consumer<MessageProvider>(
                builder: (context, messageProvider, _) {
                  return ListView.builder(
                    itemCount: messageProvider.messages[widget.contactName]?.length ?? 0,
                    itemBuilder: (context, index) {
                      String message = messageProvider.messages[widget.contactName]![index];
                      return ListTile(
                        title: Text(message),
                      );
                    },
                  );
                },
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
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Сообщения',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    sendMessage(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void sendMessage(BuildContext context) {
    String message = messageController.text;
    if (message.isNotEmpty) {
      MessageProvider messageProvider = Provider.of<MessageProvider>(context, listen: false);
      
      messageProvider.addMessage(widget.contactName, message);
      messageController.clear();
    }
  }
}
