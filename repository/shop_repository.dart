// ignore_for_file: body_might_complete_normally_nullable, cast_nullable_to_non_nullable, lines_longer_than_80_chars, prefer_single_quotes

import 'dart:async';

import '../constant/constant.dart';
import '../database/postgres.dart';
import '../log/log.dart';
import '../model/book.dart';
import '../model/shop.dart';

class IShopRepo {
  void queryShopInfo(Book book) {}
}

class ShopRepository implements IShopRepo {
  ShopRepository(this._db, this._logger);
  final Database _db;
  final AppLogger _logger;

  @override
  Future<Shop> queryShopInfo(Book book) async {
    final completer = Completer<Shop>();
    const query = 'SELECT * FROM shop WHERE shop.name = @shopname';
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
          name: firstRow['name'].toString(),
          image: firstRow['image'].toString(),
          number_books: firstRow['number_books'].toString(),
          address: firstRow['address'].toString(),
        ),
      );
    }
    return completer.future;
  }
}
