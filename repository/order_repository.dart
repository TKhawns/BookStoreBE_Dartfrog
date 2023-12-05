// ignore_for_file: body_might_complete_normally_nullable, cast_nullable_to_non_nullable, prefer_single_quotes, non_constant_identifier_names, annotate_overrides, lines_longer_than_80_chars

import 'dart:async';

import '../constant/constant.dart';
import '../database/postgres.dart';
import '../log/log.dart';
import '../model/book.dart';
import '../model/dash_data.dart';

class IOrderRepo {
  Future<int>? addBook(Book book, String customerId) {}
  Future<int>? updateOrder(
    String? quantity,
    String? order_id,
    String? customerId,
  ) {}
  Future<int>? deleteOrder(String? order_id, String? customerId) {}
  void queryBookList(String customerId) {}
  void countOrder(String id) {}
  void getDataDash(String id) {}
}

class OrderRepository implements IOrderRepo {
  OrderRepository(this._db, this._logger);
  final Database _db;
  final AppLogger _logger;

  @override
  Future<int> addBook(Book book, String customerId) async {
    final completer = Completer<int>();
    const query = '''
          INSERT INTO orders(order_id, title, description, image, price, shipcost, shopname, shop_image, authorname, number_books, score, quantity, customer_id, status)
          SELECT @order_id, @title, @description, @image, @price, @shipcost, @shopname, @shop_image, @authorname, @number_books, @score, @quantity, @customer_id, @status
          FROM orders
          WHERE NOT EXISTS (SELECT order_id, title, description, image, price, shipcost, shopname, shop_image, authorname, number_books, score, quantity, customer_id, status FROM orders WHERE customer_id = @customer_id AND title = @title AND status != 'payment') LIMIT 1;
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
      'customer_id': customerId,
      'status': 'order',
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

  Future<int> updateOrder(
    String? quantity,
    String? order_id,
    String? customerId,
  ) async {
    final completer = Completer<int>();
    const query = '''
          UPDATE orders SET quantity = @quantity WHERE order_id = @order_id AND customer_id = @customer_id;
        ''';
    final params = {
      'quantity': quantity,
      'order_id': order_id,
      'customer_id': customerId,
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

  Future<int> confirmOrder() async {
    final completer = Completer<int>();
    const query = '''
          UPDATE orders SET status = @status WHERE status = 'payment';
        ''';
    final params = {
      'status': 'confirm',
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

  Future<int> setPaymentStatus(String customerId) async {
    final completer = Completer<int>();
    const query = '''
          UPDATE orders SET status = 'payment' WHERE customer_id = @customer_id;
        ''';
    final params = {
      'customer_id': customerId,
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
  Future<List<Book>> queryBookList(String customerId) async {
    final completer = Completer<List<Book>>();
    const query =
        'SELECT * FROM orders WHERE customer_id = @id  AND status = @status ORDER BY order_id ASC;';
    final params = {'id': customerId, 'status': 'order'};

    final result = await _db.executor.query(query, substitutionValues: params);
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
  Future<dynamic> countOrder(String id) async {
    final completer = Completer<dynamic>();
    const query =
        'SELECT COUNT(order_id) as total FROM orders WHERE customer_id = @id AND status = @status;';
    final params = {
      'id': id,
      'status': 'order',
    };
    final result = await _db.executor.query(
      query,
      substitutionValues: params,
    );
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

  @override
  Future<DashBoardData> getDataDash(String id) async {
    final completer = Completer<DashBoardData>();
    const query =
        'select u.full_name as shop_name, COUNT(order_id) as total_order, COUNT(order_id) as new_order from orders JOIN users u ON u.id = @id and u.full_name = orders.shopname where status = @status GROUP BY shop_name;';
    final params = {
      'id': id,
      'status': 'payment',
      'role': 'shop',
    };
    final result = await _db.executor.query(
      query,
      substitutionValues: params,
    );
    if (result.isEmpty) {
      _logger.debugSql(
        query,
        "no result",
        message: ExSql.statusRecordNotFound.toString(),
      );
      completer.completeError(ExSql.statusRecordNotFound);
      return completer.future;
    } else {
      final row = result[0].toColumnMap();
      completer.complete(
        DashBoardData(
          shop_name: row['shop_name'].toString(),
          total_order: row['total_order'].toString(),
          new_order: row['new_order'].toString(),
        ),
      );
    }
    return completer.future;
  }

  Future<int> deleteOrder(String? order_id, String? customerId) async {
    final completer = Completer<int>();
    const query = '''
          DELETE FROM orders WHERE order_id = @order_id AND customer_id = @customer_id;
        ''';
    final params = {
      'order_id': order_id,
      'customer_id': customerId,
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
