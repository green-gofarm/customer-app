import 'package:logger/logger.dart';

class AppLoggerFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {

    // if(event.level == Level.error || event.level == Level.warning) {
    //   return true;
    // }
    //
    // return false;

    return false;
  }
}