// message_provider.dart
import 'package:flutter/material.dart';

class MessageProvider with ChangeNotifier {
  Map<String, List<String>> _messages = {};

  Map<String, List<String>> get messages => _messages;

  void addMessage(String contactName, String message) {
    if (!_messages.containsKey(contactName)) {
      _messages[contactName] = [];
    }
    _messages[contactName]!.add(message);
    notifyListeners();
  }

  String getLastMessage(String contactName) { 
    List<String>? messages = _messages[contactName];
    return messages != null && messages.isNotEmpty ? messages.last : "";
  }
}


