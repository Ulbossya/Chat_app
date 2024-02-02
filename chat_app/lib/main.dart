//main.dart
import 'package:chat_app/chat_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'message_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MessageProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatListScreen(),
    );
  }
}
