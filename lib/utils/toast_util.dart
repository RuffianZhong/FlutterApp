import 'dart:ui';

import 'package:fluttertoast/fluttertoast.dart';

///吐司工具类
class ToastUtil {
  ///显示吐司
  static showToast(
      {required String msg,
      double? fontSize,
      ToastGravity? gravity,
      Color? backgroundColor,
      Color? textColor}) {
    Fluttertoast.showToast(msg: msg);
  }
}
