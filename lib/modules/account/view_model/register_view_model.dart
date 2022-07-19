import 'package:flutter/cupertino.dart';

import '../model/account_model.dart';

class RegisterViewModel extends ChangeNotifier {
  late AccountModel model;

  RegisterViewModel() {
    model = AccountModel();
  }

  ///允许登录
  bool _canRegister = false;

  bool get canRegister => _canRegister;

  set canRegister(bool value) {
    _canRegister = value;
    notifyListeners();
  }

  ///密码模式
  bool _secretPsw = true;

  bool get secretPsw => _secretPsw;

  set secretPsw(bool value) {
    _secretPsw = value;
    notifyListeners();
  }

  ///确认密码模式
  bool _secretPswConfirm = true;

  bool get secretPswConfirm => _secretPswConfirm;

  set secretPswConfirm(bool value) {
    _secretPswConfirm = value;
    notifyListeners();
  }
}
