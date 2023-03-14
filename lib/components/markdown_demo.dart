import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/services.dart' show rootBundle;

class MarkdownDemo extends StatefulWidget {
  @override
  _MarkdownDemoState createState() => _MarkdownDemoState();
}

class _MarkdownDemoState extends State<MarkdownDemo> {
  String _markdownData = '';

  @override
  void initState() {
    super.initState();
    _loadMarkdownData();
  }

  Future<void> _loadMarkdownData() async {
    _markdownData = await rootBundle.loadString('prompts.md');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Markdown Demo'),
      ),
      body: _markdownData.isNotEmpty
          ? Markdown(data: _markdownData)
          : const Center(child: CircularProgressIndicator()),
    );
  }
}