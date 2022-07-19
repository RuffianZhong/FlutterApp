import 'package:flutter_wan_android/modules/account/model/user_entity.dart';

import '../../../common/global_value.dart';
import '../../../core/net/cancel/http_canceler.dart';
import '../../../core/net/http_request.dart';
import '../../../core/net/http_result.dart';

class AccountModel {
  ///登录
  String loginApi = "user/login";

  ///注册
  String registerApi = "user/register";

  ///退出登录
  String logoutApi = "user/logout/json";

  ///登录
  Future<HttpResult<UserEntity>> login(
      String account, String psw, HttpCanceler? canceler) async {
    ///参数
    Map<String, dynamic>? params = {"username": account, "password": psw};

    ///结果
    Map<String, dynamic> value =
        await HttpRequest.post(loginApi, params: params, canceler: canceler);

    return HttpResult<UserEntity>().convert(value);
  }

  ///注册
  Future<HttpResult<UserEntity>> register(String account, String psw,
      String confirmPsw, HttpCanceler? canceler) async {
    ///参数
    Map<String, dynamic>? params = {
      "username": account,
      "password": psw,
      "repassword": confirmPsw
    };

    ///结果
    Map<String, dynamic> value =
        await HttpRequest.post(registerApi, params: params, canceler: canceler);

    return HttpResult<UserEntity>().convert(value);
  }

  ///退出登录
  Future logout(HttpCanceler? canceler) async {
    return await HttpRequest.post(registerApi, canceler: canceler);
  }

  ///保存登录数据
  void saveUserData(UserEntity entity) {
    GlobalValue.setLoginState(entity.uid ?? 0);
    GlobalValue.setUserAccount(entity.nickname ?? "");
  }

  ///获取账号信息
  Future<String?> getUserAccount() async {
    return await GlobalValue.getUserAccount();
  }
}
