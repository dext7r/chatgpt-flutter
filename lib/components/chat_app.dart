import 'package:flutter/material.dart';
import 'chat_screen.dart';

class ChatApp extends StatelessWidget {
  const ChatApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'chatGpt',
      home: ChatScreen(),
    );
  }
}
