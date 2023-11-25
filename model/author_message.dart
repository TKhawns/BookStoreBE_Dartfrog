// ignore_for_file: sort_constructors_first

class AuthorMessage {
  String? id;
  String? name;
  AuthorMessage({this.id, this.name});

  Map<String, dynamic> toJson() => {
        'firstName': name,
        'id': id,
      };
}
