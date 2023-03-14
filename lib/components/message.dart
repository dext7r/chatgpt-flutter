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