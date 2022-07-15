import 'package:flutter/cupertino.dart';
import 'package:flutter_wan_android/modules/account/model/user_entity.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../common/global_value.dart';
import '../../../core/lifecycle/zt_lifecycle.dart';
import '../../../core/net/cancel/http_canceler.dart';
import '../model/account_model.dart';

class LoginViewModel extends ChangeNotifier {
  late AccountModel model;

  LoginViewModel() {
    model = AccountModel();
  }

  ///允许登录
  bool _canLogin = false;

  bool get canLogin => _canLogin;

  set canLogin(bool value) {
    _canLogin = value;
    notifyListeners();
  }

  ///密码模式
  bool _obscureText = false;

  bool get obscureText => _obscureText;

  set obscureText(bool value) {
    _obscureText = value;
    notifyListeners();
  }

  ///登录成功
  void loginSuccess(UserEntity entity) {
    GlobalValue.setLoginState(entity.uid ?? 0);
  }

  ///登录
  void login(String account, String psw, WidgetLifecycleOwner lifecycleOwner) {
    model.login(account, psw, HttpCanceler(lifecycleOwner)).then((value) {
      ///articleList = value.datas;
    }).onError((error, stackTrace) {
      Fluttertoast.showToast(msg: "登录失败");
    });
  }
}
