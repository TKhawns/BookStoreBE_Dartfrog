import 'dart:async';
import 'package:postgres/postgres.dart';

class Database {
  Database(this.dbHost, this.dbPort, this.dbName, {this.dbUser, this.dbPass});

  late String dbHost;
  late int dbPort;
  late String dbName;
  String? dbUser;
  String? dbPass;

  late PostgreSQLConnection executor;
  Future<PostgreSQLConnection> connect() async {
    final completer = Completer<PostgreSQLConnection>();
    executor = PostgreSQLConnection(
      dbHost,
      dbPort,
      dbName,
      username: dbUser,
      password: dbPass,
    );
    try {
      await executor.open();
      completer.complete(executor);
    } catch (e) {
      completer.completeError(e);
    }
    return completer.future;
  }
}
