import 'package:flutter/material.dart';
import 'package:flutter_wan_android/modules/account/model/user_entity.dart';

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
}
