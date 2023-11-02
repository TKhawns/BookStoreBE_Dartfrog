// ignore_for_file: avoid_dynamic_calls

import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../../constant/constant.dart';
import '../../controllers/user_controller.dart';
import '../../model/response.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method.value != 'POST') {
    return AppResponse()
        .error(HttpStatus.methodNotAllowed, AppMsg.msgMethodNotAllow);
  }

  final userController = context.read<UserController>();
  // Access the request body as parsed `JSON`.
  final body = await context.request.json();

  try {
    final user = await userController.handleLogin(
      body['email'].toString(),
      body['password'].toString(),
    );
    return AppResponse().ok(HttpStatus.ok, user);
  } catch (e) {
    return AppResponse().error(HttpStatus.internalServerError, e.toString());
  }
}
