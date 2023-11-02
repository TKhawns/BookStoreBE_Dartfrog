import 'dart:async';
import 'package:dart_frog/dart_frog.dart';

class AppResponse {
  AppResponse({this.statusCode, this.message, this.data});
  int? statusCode;
  String? message;
  Object? data;

  Map<String, dynamic> toJsonOk() => {
        'code': statusCode,
        'message': 'OK',
        'data': data,
      };

  Map<String, dynamic> toJsonErr() => {
        'code': statusCode,
        'message': message,
      };

  Future<Response> ok(int code, Object? data) {
    final completer = Completer<Response>();
    final response = Response.json(
      body: AppResponse(
        statusCode: code,
        data: data,
      ).toJsonOk(),
    );

    completer.complete(response);
    return completer.future;
  }

  Future<Response> error(int code, String message) {
    final completer = Completer<Response>();
    final response = Response.json(
      statusCode: code,
      body: AppResponse(
        statusCode: code,
        message: message,
      ).toJsonErr(),
    );
    completer.complete(response);
    return completer.future;
  }
}
