// ignore_for_file: avoid_dynamic_calls

import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../../constant/constant.dart';
import '../../controllers/shop_controller.dart';
import '../../exception/record_not_found.dart';
import '../../model/book.dart';
import '../../model/response.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method.value != 'GET') {
    return AppResponse()
        .error(HttpStatus.methodNotAllowed, AppMsg.msgMethodNotAllow);
  }

  final shopController = context.read<ShopController>();
  final body = await context.request.json();
  final bookReg = Book(
    shopName: body['shopName'].toString(),
  );
  try {
    final bookDb = await shopController.handleShopList(bookReg);
    return AppResponse().ok(HttpStatus.ok, bookDb);
  } catch (e) {
    var statusCode = HttpStatus.internalServerError;
    if (e is RecordNotFound) {
      statusCode = HttpStatus.notFound;
    }
    return AppResponse().error(statusCode, e.toString());
  }
}
