// ignore_for_file: non_constant_identifier_names

class Author {
  Author({
    this.author_id,
    this.full_name,
    this.description,
    this.image,
    this.number_books,
    this.link_youtube,
  });
  String? author_id;
  String? full_name;
  String? description;
  String? image;
  String? number_books;
  String? link_youtube;

  Map<String, dynamic> toJson() => {
        'author_id': author_id,
        'full_name': full_name,
        'description': description,
        'image': image,
        'number_books': number_books,
        'link_youtube': link_youtube,
      };

  @override
  String toString() {
    return '''
      {
        author_id = $author_id,
        description = $description,
        image: $image,
        number_books = $number_books,
        link_youtube = $link_youtube
      }
      ''';
  }
}
