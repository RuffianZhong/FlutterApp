import 'package:flutter/material.dart';
import 'package:flutter_wan_android/common/global_value.dart';
import 'package:flutter_wan_android/modules/account/model/user_entity.dart';
import 'package:flutter_wan_android/modules/main/view_model/locale_view_model.dart';
import 'package:flutter_wan_android/modules/main/view_model/theme_view_model.dart';
import 'package:provider/provider.dart';

import '../../account/model/account_model.dart';

/// me页面的ViewModel
class MeViewModel extends ChangeNotifier {
  late AccountModel model;

  MeViewModel() {
    model = AccountModel();
  }

  ///用户信息实体类
  UserEntity _userEntity = UserEntity();

  UserEntity get userEntity => _userEntity;

  set userEntity(UserEntity value) {
    _userEntity = value;
    notifyListeners();
  }

  ///是否已经登录
  bool _isLogin = false;

  bool get isLogin => _isLogin;

  set isLogin(bool value) {
    _isLogin = value;
    notifyListeners();
  }

  ///多语言下标
  int _localIndexValue = 0;

  int get localIndexValue => _localIndexValue;

  set localIndexValue(int value) {
    _localIndexValue = value;
    notifyListeners();
  }

  ///主题下标
  int _themeIndex = ThemeViewModel.defaultThemeIndex;

  int get themeIndex => _themeIndex;

  set themeIndex(int value) {
    _themeIndex = value;
    notifyListeners();
  }

  ///是否暗黑模式
  bool _darkMode = false;

  bool get darkMode => _darkMode;

  set darkMode(bool value) {
    _darkMode = value;
    notifyListeners();
  }

  ///初始化用户信息
  void initUserData() async {
    isLogin = await model.isLogin();

    if (isLogin) {
      userEntity = await model.getUser();
    }
  }

  ///初始化本地化信息
  void initLocalData(BuildContext context) {
    localIndexValue = context.read<LocaleViewModel>().localIndex;
  }

  ///初始化主题信息
  void initThemeData(BuildContext context) {
    ThemeViewModel viewModel = context.read<ThemeViewModel>();
    themeIndex = viewModel.themeIndex;
    darkMode = viewModel.darkMode;
  }
}
