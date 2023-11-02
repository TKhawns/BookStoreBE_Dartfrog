// ignore_for_file: non_constant_identifier_names

class Shop {
  Shop({
    this.name,
    this.address,
    this.number_books,
    this.image,
  });
  String? name;
  String? address;
  String? image;
  String? number_books;

  Map<String, dynamic> toJson() => {
        'name': name,
        'address': address,
        'image': image,
        'number_books': number_books,
      };

  @override
  String toString() {
    return '''
      {name = $name,
        'address': $address,
        'image': $image,
        'number_books': $number_books}
      ''';
  }
}
