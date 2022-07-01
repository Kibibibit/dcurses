import 'dart:io';

import 'loglevel.dart';

class Log {

  late String _name;
  late String _filename;

  Log(String name) {
    _name = name;
    _filename = "logs/$_start.log";
  }

  static String _dateTimeStringLong(DateTime dateTime) {
    return "${dateTime.year}-${dateTime.month}-${dateTime.day}-${_dateTimeStringShort(dateTime)}";
  }

  static String _dateTimeStringShort(DateTime dateTime) {
    return "${dateTime.hour}-${dateTime.minute}-${dateTime.second}";
  } 

  static final String _start = "${_dateTimeStringLong(DateTime.now())}";

  String _level(LogLevel level) {
    return "[${level.name.toUpperCase()}]";
  }

  void info(String message) {
    _log(LogLevel.info, message);
  }

  void warning(String message) {
    _log(LogLevel.warning, message);
  }

  void error(String message) {
    _log(LogLevel.error, message);
  }

  void debug(String message) {
    _log(LogLevel.debug, message);
  }


  void _log(LogLevel level, String message) {
    String line = "[${_dateTimeStringShort(DateTime.now())}][$_name]${_level(level)} $message";
    File file = File(_filename);
    IOSink sink = file.openWrite();
    sink.writeln(line);
    sink.close();

  }
  
  


}