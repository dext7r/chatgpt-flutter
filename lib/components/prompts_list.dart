import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class PromptsList extends StatefulWidget {
  @override
  _PromptsListState createState() => _PromptsListState();
}

class _PromptsListState extends State<PromptsList> {
  List<Map<String, dynamic>> _prompts = [];

  @override
  void initState() {
    super.initState();
    _loadPrompts();
  }

  Future<void> _loadPrompts() async {
    final String data = await rootBundle.loadString('prompts.md');
    final List<String> lines = data.split('\n');
    final List<Map<String, dynamic>> prompts = [];
    Map<String, dynamic> prompt = {};

    for (final String line in lines) {
      if (line.startsWith('## ')) {
        if (prompt.isNotEmpty) prompts.add(prompt);
        prompt = {
          'title': line.substring(3),
          'questions': '',
        };
      } else if (line.length > 4) {
        prompt['questions'] += line + '\n';
      }
    }
    prompts.add(prompt);
    setState(() {
      _prompts = prompts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prompts'),
      ),
      body: ListView.builder(
        itemCount: _prompts.length,
        itemBuilder: (context, index) {
          final Map<String, dynamic> prompt = _prompts[index];
          return ListTile(
            title: Text('${index + 1}. ${prompt['title']}'),
            subtitle: Text(prompt['questions']),
            onTap: () {
              Navigator.pop(context, prompt);
            },
          );
        },
      ),
    );
  }
}