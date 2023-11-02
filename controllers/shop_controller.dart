// ignore_for_file: null_argument_to_non_null_type, unnecessary_cast

import 'dart:async';
import '../exception/general_exp.dart';
import '../log/log.dart';
import '../model/book.dart';
import '../model/shop.dart';
import '../repository/shop_repository.dart';

class ShopController {
  ShopController(this._shopRepository, this._logger);
  final ShopRepository _shopRepository;
  final AppLogger _logger;

  Future<Shop> handleShopList(Book book) async {
    final completer = Completer<Shop>();
    final errMsgList = <String>[];

    if (errMsgList.isNotEmpty) {
      final errors = errMsgList.join(',');
      _logger.log.info(errors);
      completer.completeError(GeneralException(errors));
      return completer.future;
    }

    try {
      final shopDb = await _shopRepository.queryShopInfo(book);
      completer.complete(shopDb);
      return completer.future;
    } catch (e) {
      completer.completeError(e);
    }
    return completer.future;
  }
}
