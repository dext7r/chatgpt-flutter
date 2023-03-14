import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'prompts_list.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class Message {
  late String author; // message author
  late String content; // message content
  late DateTime timestamp; // message timestamp

  Message({
    required this.author,
    required this.content,
    required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      author: json['author'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() => {
    'author': author,
    'content': content,
    'timestamp': timestamp.toIso8601String(),
  };
}

class _ChatScreenState extends State<ChatScreen> {
  List<Map<String, dynamic>> _messages = []; // list of messages
  final _controller =
  TextEditingController(); // text controller to input messages
  final String _apiKey = dotenv.env['API_KEY']!; // API key
  final String _model = "gpt-3.5-turbo-0301"; // GPT model
  bool _isCopied = false; // whether the message has been copied to clipboard
  bool _isLoading = false; // whether the app is loading
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(_updateFloatingActionButtonVisibility);
  }

  @override
  void dispose() {
    _textEditingController
        .removeListener(_updateFloatingActionButtonVisibility);
    _textEditingController.dispose();
    super.dispose();
  }

  void _updateFloatingActionButtonVisibility() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('chatGpt'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (BuildContext context, int index) {
                final bool isUserMessage = _messages[index]['author'] == 'user';
                return ListTile(
                  title: MarkdownBody(
                    data: _messages[index]['content'] ?? '',
                    selectable: true,
                    styleSheet: MarkdownStyleSheet(
                      p: TextStyle(
                        color: _messages[index]['color'] ?? Colors.black,
                      ),
                    ),
                  ),
                  subtitle: Text(
                    DateFormat.yMd().add_jm().format(
                      DateTime.parse(_messages[index]['timestamp'] ?? ''),
                    ),
                  ),
                  leading: isUserMessage
                      ? CircleAvatar(
                    child: Icon(Icons.person, color: Colors.white),
                  )
                      : CircleAvatar(
                    child: Icon(Icons.android, color: Colors.green),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  isThreeLine: false,
                  dense: false,
                  trailing: !isUserMessage
                      ? InkWell(
                    onTap: () =>
                        _copyToClipboard(_messages[index]['content']),
                    onLongPress: () => setState(() {
                      _isCopied = true;
                      _copyToClipboard(_messages[index]['content']);
                    }),
                    onTapCancel: () => setState(() {
                      _isCopied = false;
                    }),
                    child: Container(
                      padding: EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color: _isCopied
                            ? Colors.blueGrey.shade300
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Icon(Icons.content_copy),
                    ),
                  )
                      : null,
                );
              },
            ),
          ),
          Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      autofocus: false,
                      maxLines: null,
                      controller: _controller,
                      onFieldSubmitted: _handleSubmit,
                      style: TextStyle(fontSize: 16),
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        hintText: 'Send a message',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                    if (_controller.text.length > 0) {
                      _handleSubmit(_controller.text);
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                  },
                ),
                if (_isLoading)
                  Container(
                    alignment: Alignment.center,
                    color: Colors.white70,
                    child: CircularProgressIndicator(),
                  ),
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () async {
                    final selectedPrompt = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PromptsList()),
                    );
                    if (selectedPrompt != null) {
                      _controller.text = selectedPrompt['questions'];
                    }
                  },
                ),
                if (_messages.isNotEmpty || _textEditingController.text.isNotEmpty)
                  Positioned(
                    bottom: 0,
                    left: 30.0,
                    child: SizedBox(
                      width: 30.0,
                      height: 30.0,
                      child: FloatingActionButton(
                        onPressed: () {
                          setState(() {
                            _messages.clear();
                            _textEditingController.clear();
                          });
                        },
                        child: Icon(Icons.delete),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleSubmit(String text) async {
    setState(() {
      _isLoading = true; // set loading to true
    });
    _controller.clear();
    final author = 'user';
    final content = text;
    setState(() {
      _messages.insert(
        0,
        {
          'author': author,
          'content': content,
          'timestamp': '${DateTime.now().toUtc()}',
        },
      );
      _isLoading = false; // set loading to false
    });

    var data = {
      'model': _model,
      'temperature': 0.6,
      'stream': false,
      'messages': [
        {'role': 'user', 'content': content}
      ]
    };

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_apiKey',
    };
    var response = await http.post(
      Uri.parse('https://chatgpt-proxy.h7ml.cn/proxy/v1/chat/completions'),
      headers: headers,
      body: json.encode(data),
    );
    var utf8Response = utf8.decode(response.bodyBytes);
    var jsonResponse = json.decode(utf8Response);
    var reply = '';
    var replyColor = Colors.black;
    if (jsonResponse.containsKey('error')) {
      var errorMessage = jsonResponse['error']['message'];
      reply = 'Error: $errorMessage';
      replyColor = Colors.red;
    } else {
      reply = jsonResponse['choices'][0]['message']['content'];
    }

    setState(() {
      _messages.insert(
        0,
        {
          'author': 'Bot', // message author: ChatGpt Bot
          'content': reply, // message content: Gpt3 response to user message
          'timestamp': '${DateTime.now().toUtc()}', // message timestamp
          'color': replyColor, // message color: red if error, black otherwise
        },
      );
    });
  }

  Future<void> _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(content: Text('Copied to clipboard')),
    )
        .closed
        .then((reason) {
      Future.delayed(Duration(milliseconds: 500), () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      });
    });
  }
}