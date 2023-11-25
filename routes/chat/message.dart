// ignore_for_file: unused_local_variable, avoid_dynamic_calls

import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../../constant/constant.dart';
import '../../controllers/message_controller.dart';
import '../../exception/record_not_found.dart';
import '../../model/response.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method.value != 'POST') {
    return AppResponse()
        .error(HttpStatus.methodNotAllowed, AppMsg.msgMethodNotAllow);
  }

  final messageController = context.read<MessageController>();
  final body = await context.request.json();
  final customerId = body['customerId'].toString();
  final shopName = body['shopName'].toString();

  try {
    final messageDb =
        await messageController.handleListMessage(customerId, shopName);
    return AppResponse().ok(HttpStatus.ok, messageDb);
  } catch (e) {
    var statusCode = HttpStatus.internalServerError;
    if (e is RecordNotFound) {
      statusCode = HttpStatus.notFound;
    }
    return AppResponse().error(statusCode, e.toString());
  }
}
