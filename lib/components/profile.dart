import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/services.dart' show rootBundle;

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State {
  String _markdownData = '';

  @override
  void initState() {
    super.initState();
    _loadMarkdownData();
  }

  Future _loadMarkdownData() async {
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
