// ignore_for_file: non_constant_identifier_names

class Book {
  Book({
    this.book_id,
    this.title,
    this.description,
    this.score,
    this.image,
    this.price,
    this.number_books,
    this.shipcost,
    this.authorName,
    this.shopName,
    this.shop_image,
    this.quantity,
  });
  String? book_id;
  String? title;
  String? description;
  String? score;
  String? image;
  String? price;
  String? number_books;
  String? shipcost;
  String? authorName;
  String? shopName;
  String? shop_image;
  String? quantity;

  Map<String, dynamic> toJson() => {
        'book_id': book_id,
        'title': title,
        'description': description,
        'score': score,
        'image': image,
        'price': price,
        'number_books': number_books,
        'shipcost': shipcost,
        'authorname': authorName,
        'shopname': shopName,
        'shop_image': shop_image,
        'quantity': quantity,
      };

  @override
  String toString() {
    return '''
      {
        book_id = $book_id,
        title =  $title,
        description = $description,
        score = $score,
        image = $image,
        price = $price,
        number_books = $number_books,
        shipcost = $shipcost,
        authorname = $authorName,
        shopname = $shopName,
        shop_image = $shop_image,
        quantity = $quantity,
      }
      ''';
  }
}
