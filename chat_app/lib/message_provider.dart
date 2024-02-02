// message_provider.dart
import 'dart:collection';
import 'package:flutter/foundation.dart';

class MessageProvider extends ChangeNotifier {
  HashMap<String, String> _lastMessages = HashMap();
  HashMap<String, List<String>> _messages = HashMap();
  String _currentUser = "YourCurrentUser"; 

  void setLastMessage(String contactName, String message) {
    _lastMessages[contactName] = message;
    notifyListeners();
  }

  String getLastMessage(String contactName) {
    return _lastMessages.containsKey(contactName) ? _lastMessages[contactName]! : "";
  }

  List<String> getMessages(String contactName) {
    return _messages.containsKey(contactName) ? _messages[contactName]! : [];
  }

  void addMessage(String contactName, String message) {
    _messages.putIfAbsent(contactName, () => []).add(message);
    setLastMessage(contactName, message);
  }

  bool isCurrentUser(String contactName) {
    return _currentUser == contactName;
  }
}
