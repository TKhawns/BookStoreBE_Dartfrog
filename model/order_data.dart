// ignore_for_file: non_constant_identifier_names

class OrderData {
  OrderData({
    this.title,
    this.image,
    this.name,
    this.address,
    this.count,
  });
  String? title;
  String? image;
  String? name;
  String? count;
  String? address;

  Map<String, dynamic> toJson() => {
        'title': title,
        'image': image,
        'name': name,
        'count': count,
        'address': address,
      };

  @override
  String toString() {
    return '''
      {
        'title': $title,
        'image': $image,
        'name': $name,
        'count': $count,
        'address': $address,
        }
      ''';
  }
}
