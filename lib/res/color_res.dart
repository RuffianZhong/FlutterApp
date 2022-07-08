import 'package:flutter/material.dart';

/// 颜色资源
class ColorRes {
  static const Color themeMain = Color(0xFF36c1bc);

  static const MaterialColor theme = MaterialColor(
    0xFF36c1bc,
    <int, Color>{
      50: Color(0xFFE3F2FD),
      100: Color(0xffd4fcfa),
      200: Color(0xffa7f8f5),
      300: Color(0xff70efeb),
      400: Color(0xff41d0cc),
      500: Color(0xFF36c1bc),
      600: Color(0xff21b2ad),
      700: Color(0xff159b96),
      800: Color(0xff098a84),
      900: Color(0xff046562),
    },
  );

  ///字体-内容-主级
  static const Color tContentMain = Color(0xff050505);

  ///字体-内容-副级
  static const Color tContentSub = Color(0xff787978);

  ///字体-标题-主级
  static const Color tTitleMain = Color(0xFF36c1bc);

  ///字体-标题-主级
  static const Color tTitleSub = Color(0xFF36c1bc);
}
