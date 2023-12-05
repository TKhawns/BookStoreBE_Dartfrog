// ignore_for_file: body_might_complete_normally_nullable, cast_nullable_to_non_nullable, lines_longer_than_80_chars, prefer_single_quotes

import 'dart:async';

import '../constant/constant.dart';
import '../database/postgres.dart';
import '../log/log.dart';
import '../model/book.dart';
import '../model/shop.dart';

class IShopRepo {
  void queryShopInfo(Book book) {}
  void queryBookList(String shopname) {}
}

class ShopRepository implements IShopRepo {
  ShopRepository(this._db, this._logger);
  final Database _db;
  final AppLogger _logger;

  @override
  Future<Shop> queryShopInfo(Book book) async {
    final completer = Completer<Shop>();
    const query = 'SELECT * FROM users WHERE users.full_name = @shopname';
    final params = {
      'shopname': book.shopName,
    };
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
      final firstRow = result.first.toColumnMap();
      completer.complete(
        Shop(
          name: firstRow['full_name'].toString(),
          image: firstRow['avatar'].toString(),
          number_books: firstRow['number_books'].toString(),
          address: firstRow['address'].toString(),
        ),
      );
    }
    return completer.future;
  }

  @override
  Future<List<Book>> queryBookList(String shopname) async {
    final completer = Completer<List<Book>>();
    const query = '''
            SELECT b.book_id, b.title, description, b.score, b.image, b.price, b.number_books, b.shipcost, b.authorname, b.shopname, b.shop_image, b.quantity
            FROM books b JOIN shop ON b.shopname = @name
        ''';
    final params = {
      'name': shopname,
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
      final books = <Book>[];
      for (var i = 0; i < result.length; i++) {
        final row = result[i].toColumnMap();
        books.add(
          Book(
            book_id: row['book_id'].toString(),
            title: row['title'].toString(),
            description: row['description'].toString(),
            score: row['score'].toString(),
            image: row['image'].toString(),
            price: row['price'].toString(),
            number_books: row['number_books'].toString(),
            shipcost: row['shipcost'].toString(),
            authorName: row['authorname'].toString(),
            shopName: row['shopname'].toString(),
            shop_image: row['shop_image'].toString(),
            quantity: row['quantity'].toString(),
          ),
        );
      }
      completer.complete(books);
    }
    return completer.future;
  }
}
