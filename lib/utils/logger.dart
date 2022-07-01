import 'package:flutter/foundation.dart';

/// 日志工具类
class Logger {
  static void log(Object? object) {
    if (kDebugMode) {
      print(object);
    }
  }
}
