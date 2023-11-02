import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'database/postgres.dart';
import 'log/log.dart';

final database = Database(
  'localhost',
  5432,
  'bookstore_dart',
  dbUser: 'postgres',
  dbPass: '10012003',
);

final appLogger = AppLogger();

Future<HttpServer> run(Handler handler, InternetAddress ip, int port) async {
  await database.connect();
  appLogger.initLog();
  return serve(handler.use(setupHandler()), ip, port);
}

Middleware setupHandler() {
  return (handler) {
    return handler
        .use(
          provider<Database>(
            (context) => database,
          ),
        )
        .use(
          provider<AppLogger>(
            (context) => appLogger,
          ),
        );
  };
}
