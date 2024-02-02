// chat_screen.dart
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
  bool isVoiceMessage = false;
  FocusNode messageFocusNode = FocusNode();

  void _showAttachDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo),
                title: Text('Фото'),
                onTap: () {
                
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.file_copy),
                title: Text('Документ'),
                onTap: () {
                 
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

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
                  List<String> messages =
                      messageProvider.getMessages(widget.contactName) ?? [];

                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      String message = messages[index];
                      bool isCurrentUser =
                          messageProvider.isCurrentUser(widget.contactName);

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            isVoiceMessage = false;
                          });
                          messageFocusNode.unfocus();
                        },
                        child: Row(
                          mainAxisAlignment: isCurrentUser
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.end,
                          children: [
                            if (!isCurrentUser)
                        
                            Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 4.0,
                              ),
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: isCurrentUser
                                    ? Color.fromRGBO(60, 237, 120, 1)
                                    : Colors.green,
                                borderRadius: isCurrentUser
                                    ? BorderRadius.only(
                                        topLeft: Radius.circular(8.0),
                                        topRight: Radius.circular(8.0),
                                        bottomRight: Radius.circular(8.0),
                                      )
                                    : BorderRadius.only(
                                        topLeft: Radius.circular(8.0),
                                        topRight: Radius.circular(8.0),
                                        bottomLeft: Radius.circular(8.0),
                                      ),
                              ),
                              child: Text(
                                message,
                                style: TextStyle(
                                  color: isCurrentUser
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ],
                        ),
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
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.attach_file),
                        onPressed: () {
                          _showAttachDialog(context);
                        },
                      ),
                      Expanded(
                        child: TextField(
                          controller: messageController,
                          focusNode: messageFocusNode,
                          decoration: InputDecoration(
                            hintText: 'Сообщения',
                          ),
                          onTap: () {
                            setState(() {
                              isVoiceMessage = false;
                            });
                          },
                          onChanged: (text) {
                            setState(() {
                              isVoiceMessage = text.isNotEmpty;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                if (isVoiceMessage)
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      sendMessage(context);
                    },
                  )
                else
                  IconButton(
                    icon: Icon(Icons.mic),
                    onPressed: () {
                      setState(() {
                        isVoiceMessage = !isVoiceMessage;
                      });
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
      MessageProvider messageProvider =
          Provider.of<MessageProvider>(context, listen: false);

      messageProvider.addMessage(widget.contactName, message);

      setState(() {
        messageController.clear();
        isVoiceMessage = false;
      });

      messageFocusNode.unfocus();
    }
  }
}
