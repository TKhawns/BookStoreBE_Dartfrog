import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../../constant/constant.dart';
import '../../controllers/order_controller.dart';
import '../../exception/record_not_found.dart';
import '../../model/response.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method.value != 'GET') {
    return AppResponse()
        .error(HttpStatus.methodNotAllowed, AppMsg.msgMethodNotAllow);
  }

  final orderController = context.read<OrderController>();
  try {
    final bookDb = await orderController.handeCountOrder();
    return AppResponse().ok(HttpStatus.ok, bookDb);
  } catch (e) {
    var statusCode = HttpStatus.internalServerError;
    if (e is RecordNotFound) {
      statusCode = HttpStatus.notFound;
    }
    return AppResponse().error(statusCode, e.toString());
  }
}
