// ignore_for_file: non_constant_identifier_names

class DashBoardData {
  DashBoardData({
    this.shop_name,
    this.total_order,
    this.new_order,
  });
  String? shop_name;
  String? total_order;
  String? new_order;

  Map<String, dynamic> toJson() => {
        'shop_name': shop_name,
        'total_order': total_order,
        'new_order': new_order,
      };

  @override
  String toString() {
    return '''
      {shop_name = $shop_name,
        'total_order': $total_order,
        'new_order': $new_order}
      ''';
  }
}
