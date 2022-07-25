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
  MaterialColor _themeColor = themeList[defaultThemeIndex];

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
    ThemeData theme = ThemeData(
      brightness: darkMode ? Brightness.dark : Brightness.light,
      primarySwatch: themeColor,
      primaryColor: themeColor,
    );
    return theme;
  }
}
