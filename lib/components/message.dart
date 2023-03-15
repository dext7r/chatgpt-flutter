import 'package:flutter/material.dart';

class Message {
  final String author;
  final String content;
  final DateTime timestamp;
  final Color color;

  Message({
    required this.author,
    required this.content,
    required this.timestamp,
    required this.color,
  });

  Map<String, dynamic> toJson() => {
        'author': author,
        'content': content,
        'timestamp': timestamp.toIso8601String(),
        'color': color.value
      };

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        author: json['author'],
        content: json['content'],
        timestamp: DateTime.parse(json['timestamp']),
        color: Color(json['color']),
      );

  @override
  String toString() {
    return 'Message{author: $author, content: $content, timestamp: $timestamp}';
  }
}
