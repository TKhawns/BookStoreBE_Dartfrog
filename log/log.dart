import 'package:logging/logging.dart';

class AppLogger {
  late Logger log;

  void initLog() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      // ignore: avoid_print
      print('${record.level.name}: ${record.time}: ${record.message}');
    });

    log = Logger('MyClassName');
  }

  void debugSql(
    String query,
    dynamic params, {
    dynamic result,
    String? message,
  }) {
    log.info({
      'query': query,
      'params': params,
      'message': message,
      'result': result,
    });
  }
}
