// ignore_for_file: avoid_dynamic_calls

import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../../constant/constant.dart';
import '../../controllers/message_controller.dart';
import '../../model/author_message.dart';
import '../../model/message.dart';
import '../../model/response.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method.value != 'POST') {
    return AppResponse()
        .error(HttpStatus.methodNotAllowed, AppMsg.msgMethodNotAllow);
  }

  final messageController = context.read<MessageController>();
  // Access the request body as parsed `JSON`.
  final body = await context.request.json();
  final orderReq = Message(
    id: body['mess_id'].toString(),
    createAt: int.parse(body['create_at'].toString()),
    status: body['status'].toString(),
    text: body['mess_text'].toString(),
    type: body['mess_type'].toString(),
    author: AuthorMessage(id: body['user_id'].toString()),
  );
  final shopName = body['shopName'].toString();

  try {
    final request =
        await messageController.handleAddMessage(orderReq, shopName);
    return AppResponse().ok(HttpStatus.ok, request);
  } catch (e) {
    return AppResponse().error(HttpStatus.internalServerError, e.toString());
  }
}
