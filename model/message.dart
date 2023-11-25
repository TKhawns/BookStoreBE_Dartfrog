import 'author_message.dart';

class Message {
  Message({
    this.id,
    this.createAt,
    this.status,
    this.text,
    this.type,
    this.author,
  });
  String? id;
  int? createAt;
  String? status;
  String? text;
  String? type;
  AuthorMessage? author;

  Map<String, dynamic> toJson() => {
        'author': author,
        'createdAt': createAt,
        'id': id,
        'status': status,
        'text': text,
        'type': type,
      };

  @override
  String toString() {
    return '''
      {id = $id, create_at = $createAt, 
      status = $status, text = $text, type = $type, author = $author}
      ''';
  }
}
