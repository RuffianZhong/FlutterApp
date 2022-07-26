import 'package:flutter/material.dart';

import '../../../common/global_value.dart';

///主题ViewModel
class ThemeViewModel extends ChangeNotifier {
  ///主题列表：直接使用 Colors.primaries
  static const List<MaterialColor> themeList = Colors.primaries;

  ///默认主题下标
  static const int defaultThemeIndex = 3;

  ///构造函数时获取本地缓存数据
  ThemeViewModel() {
    ///获取ThemeIndex
    GlobalValue.getThemeIndex().then((value) {
      themeIndex = value ?? defaultThemeIndex;
      themeColor = themeList[themeIndex];
    });

    ///获取是否暗黑模式
    GlobalValue.getDarkMode().then((value) {
      darkMode = value ?? false;
    });
  }

  ///主题下标
  int _themeIndex = defaultThemeIndex;

  int get themeIndex => _themeIndex;

  set themeIndex(int value) {
    _themeIndex = value;
    notifyListeners();
  }

  ///当前主题颜色
  MaterialColor _themeColor = themeList[7];

  MaterialColor get themeColor => _themeColor;

  set themeColor(MaterialColor value) {
    _themeColor = value;
    notifyListeners();
  }

  ///存储theme
  void setThemeIndex(int index) {
    themeColor = themeList[index];
    themeIndex = index;
    GlobalValue.setThemeIndex(index);
  }

  ///暗黑模式：系统自身设置 和 用户在App设置
  ///只有在系统设置 不是暗黑模式 时，用户才可以在App中设置
  bool _darkMode = true;

  bool get darkMode => _darkMode;

  set darkMode(bool value) {
    _darkMode = value;
    notifyListeners();
  }

  ///主题数据：主题颜色 和 暗黑模式 组合生成
  ThemeData get themeData {
    Brightness brightness = darkMode ? Brightness.dark : Brightness.light;

    ///暗黑主题
    ColorScheme dark = const ColorScheme.dark().copyWith(
      primary: themeColor[800],
      primaryVariant: themeColor[900],
      secondary: themeColor[800],
      secondaryVariant: themeColor[900],
    );

    ///高亮主题
    ColorScheme light = const ColorScheme.light().copyWith(
      primary: themeColor,
      primaryVariant: themeColor[700],
      secondary: themeColor,
      secondaryVariant: themeColor[700],
    );

    ///主题颜色值
    Color color = darkMode ? themeColor[900]! : themeColor;

    ThemeData theme = ThemeData(
      ///暗黑模式
      brightness: brightness,

      ///主题颜色
      primarySwatch: themeColor,
      primaryColor: themeColor,
      colorScheme: darkMode ? dark : light,

      ///单选按钮之类的颜色值
      toggleableActiveColor: color,

      ///导航栏指示器颜色
      indicatorColor: darkMode ? themeColor : Colors.white,

      ///文本主题
      textTheme: TextTheme(
        //item_main:18/black
        titleMedium: TextStyle(
            fontSize: 18,
            color: darkMode ? Colors.grey[100] : Colors.grey[900]),
        //item_sub:16/grey
        bodyMedium: TextStyle(
            fontSize: 16, color: darkMode ? Colors.grey : Colors.grey),
        //label_main:14/midBlack
        labelMedium: TextStyle(
            fontSize: 14,
            color: darkMode ? Colors.grey[300] : Colors.grey[700]),
      ),

      ///字体样式
      // fontFamily: 'Georgia',
    );
    return theme;
  }
}
