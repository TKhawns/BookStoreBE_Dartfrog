// ignore_for_file: body_might_complete_normally_nullable, cast_nullable_to_non_nullable, prefer_single_quotes, non_constant_identifier_names, annotate_overrides, lines_longer_than_80_chars

import 'dart:async';

import '../constant/constant.dart';
import '../database/postgres.dart';
import '../log/log.dart';
import '../model/book.dart';

class IOrderRepo {
  Future<int>? addBook(Book book) {}
  Future<int>? updateOrder(String? quantity, String? order_id) {}
  Future<int>? deleteOrder(String? order_id) {}
  void queryBookList() {}
  void countOrder() {}
}

class OrderRepository implements IOrderRepo {
  OrderRepository(this._db, this._logger);
  final Database _db;
  final AppLogger _logger;

  @override
  Future<int> addBook(Book book) async {
    final completer = Completer<int>();
    const query = '''
          INSERT INTO orders (order_id, title, description, image, price, shipcost, shopname, shop_image, authorname, number_books, score, quantity) 
          VALUES (@order_id, @title, @description, @image, @price, @shipcost, @shopname, @shop_image, @authorname, @number_books, @score, @quantity)
        ''';
    final params = {
      'order_id': book.book_id,
      'title': book.title,
      'description': book.description,
      'image': book.image,
      'price': book.price,
      'shipcost': book.shipcost,
      'shopname': book.shopName,
      'shop_image': book.shop_image,
      'authorname': book.authorName,
      'score': book.score,
      'number_books': book.number_books,
      'quantity': book.quantity,
    };
    final result = await _db.executor.query(
      query,
      substitutionValues: params,
    );
    if (result.affectedRowCount == 0) {
      completer.completeError(ExSql.insertRecordFailed);
    }

    _logger.debugSql(query, params, message: '{$result.affectedRowCount}');

    completer.complete(result.affectedRowCount);
    return completer.future;
  }

  Future<int> updateOrder(String? quantity, String? order_id) async {
    final completer = Completer<int>();
    const query = '''
          UPDATE orders SET quantity = @quantity WHERE order_id = @order_id;
        ''';
    final params = {
      'quantity': quantity,
      'order_id': order_id,
    };
    final result = await _db.executor.query(
      query,
      substitutionValues: params,
    );
    if (result.affectedRowCount == 0) {
      completer.completeError(ExSql.insertRecordFailed);
    }

    _logger.debugSql(query, params, message: '{$result.affectedRowCount}');

    completer.complete(result.affectedRowCount);
    return completer.future;
  }

  @override
  Future<List<Book>> queryBookList() async {
    final completer = Completer<List<Book>>();
    const query = 'SELECT * FROM orders ORDER BY order_id ASC;';
    final result = await _db.executor.query(query);
    if (result.isEmpty) {
      _logger.debugSql(
        query,
        "no result",
        message: ExSql.statusRecordNotFound.toString(),
      );
      completer.completeError(ExSql.statusRecordNotFound);
      return completer.future;
    } else {
      final books = <Book>[];
      for (var i = 0; i < result.length; i++) {
        final row = result[i].toColumnMap();
        books.add(
          Book(
            book_id: row['order_id'].toString(),
            title: row['title'].toString(),
            description: row['description'].toString(),
            image: row['image'].toString(),
            price: row['price'].toString(),
            shipcost: row['shipcost'].toString(),
            number_books: row['number_books'].toString(),
            shopName: row['shopname'].toString(),
            score: row['score'].toString(),
            shop_image: row['shop_image'].toString(),
            authorName: row['authorname'].toString(),
            quantity: row['quantity'].toString(),
          ),
        );
      }
      completer.complete(books);
    }
    return completer.future;
  }

  @override
  Future<dynamic> countOrder() async {
    final completer = Completer<dynamic>();
    const query = 'SELECT COUNT(order_id) as total FROM orders;';
    final result = await _db.executor.query(query);
    if (result.isEmpty) {
      _logger.debugSql(
        query,
        "no result",
        message: ExSql.statusRecordNotFound.toString(),
      );
      completer.completeError(ExSql.statusRecordNotFound);
      return completer.future;
    } else {
      final total = result[0];
      completer.complete(total[0]);
    }
    return completer.future;
  }

  Future<int> deleteOrder(String? order_id) async {
    final completer = Completer<int>();
    const query = '''
          DELETE FROM orders WHERE order_id = @order_id;
        ''';
    final params = {
      'order_id': order_id,
    };
    final result = await _db.executor.query(
      query,
      substitutionValues: params,
    );
    if (result.affectedRowCount == 0) {
      completer.completeError(ExSql.insertRecordFailed);
    }

    _logger.debugSql(query, params, message: '{$result.affectedRowCount}');

    completer.complete(result.affectedRowCount);
    return completer.future;
  }
}
