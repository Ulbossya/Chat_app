import 'dart:io';
import 'package:intl/intl.dart';
import 'package:chat_app/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart'; 
import 'package:provider/provider.dart';
import 'message_provider.dart';

class Message {
  final String text;
  final DateTime time;
  final bool isCurrentUser;

  Message(this.text, this.time, this.isCurrentUser);
}

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
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.file_copy),
                title: Text('Документ'),
                onTap: () {
                  Navigator.pop(context);
                  _pickDocument();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      sendMessage(context, pickedFile.path);
    }
  }

  Future<void> _pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'], 
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      sendMessage(context, file.path);
    }
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.contactName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'В сети',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
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
                  List<Message> messages =
                      messageProvider.getMessages(widget.contactName)?.map((msg) => Message(msg, DateTime.now(), messageProvider.isCurrentUser(widget.contactName)))?.toList() ?? [];

                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      Message message = messages[index];

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            isVoiceMessage = false;
                          });
                          messageFocusNode.unfocus();
                        },
                        child: Row(
                          mainAxisAlignment: message.isCurrentUser
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.end,
                          children: [
                            if (!message.isCurrentUser)
                              Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 4.0,
                                ),
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(60, 237, 120, 1),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8.0),
                                    topRight: Radius.circular(8.0),
                                    bottomLeft: Radius.circular(8.0),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      message.text,
                                      style: TextStyle(
                                        color: Color.fromRGBO(0, 82, 28, 1),
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    Text(
                                      DateFormat('HH:mm').format(message.time),
                                      style: TextStyle(
                                        color: Color.fromRGBO(0, 82, 28, 1),
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (message.isCurrentUser)
                              Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 4.0,
                                ),
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8.0),
                                    topRight: Radius.circular(8.0),
                                    bottomRight: Radius.circular(8.0),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      message.text,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    Text(
                                      DateFormat('HH:mm').format(message.time),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ],
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

  void sendMessage(BuildContext context, [String? message]) {
    String text = message ?? messageController.text;
    if (text.isNotEmpty) {
      MessageProvider messageProvider =
          Provider.of<MessageProvider>(context, listen: false);

      messageProvider.addMessage(widget.contactName, text);

      setState(() {
        messageController.clear();
        isVoiceMessage = false;
      });

      messageFocusNode.unfocus();
    }
  }
}
