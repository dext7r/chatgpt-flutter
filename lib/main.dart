import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'components/chat_app.dart';
import 'components/prompts_list.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(ChatApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => ChatApp(),
        // '/markdown': (context) => MarkdownDemo(),
        '/prompts': (context) => PromptsList(),
      },
    );
  }
}