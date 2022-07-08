import 'package:flutter/material.dart';
import 'package:flutter_wan_android/modules/account/model/user_entity.dart';

/// me页面的ViewModel
class MeViewModel extends ChangeNotifier {
  ///测试数据
  String _name = "";

  String get name => _name;

  set name(String value) {
    _name = value;
    notifyListeners();
  }

  ///用户信息实体类
  UserEntity _userEntity = UserEntity();

  UserEntity get userEntity => _userEntity;

  set userEntity(UserEntity value) {
    _userEntity = value;
    notifyListeners();
  }
}
