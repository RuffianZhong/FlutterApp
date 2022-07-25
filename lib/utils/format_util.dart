import 'package:intl/intl.dart';

///格式化工具类
class FormatUtil {
  ///日期格式
  static const String ymdHms = "yyyy-MM-dd HH:mm:ss";

  /// 格式化数值
  /// var f = NumberFormat("###.0#", "en_US");
  /// print(f.format(12.345));
  /// ==> 12.34
  static String formatNumber(String pattern, dynamic number, {String? locale}) {
    return NumberFormat(pattern, locale).format(number);
  }

  /// 格式化日期
  /// "yyyy-MM-dd HH:mm:ss"
  static String formatDate(String pattern, DateTime date) {
    return DateFormat(pattern).format(date);
  }

  /// 格式化毫秒日期
  /// "yyyy-MM-dd HH:mm:ss"
  static String formatMilliseconds(String pattern, int milliseconds) {
    return formatDate(
        pattern, DateTime.fromMillisecondsSinceEpoch(milliseconds));
  }
}
