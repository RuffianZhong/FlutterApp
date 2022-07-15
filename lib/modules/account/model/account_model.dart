import 'package:flutter_wan_android/modules/account/model/user_entity.dart';

import '../../../core/net/cancel/http_canceler.dart';
import '../../../core/net/http_request.dart';

class AccountModel {
  ///登录
  String loginApi = "user/login";

  ///注册
  String registerApi = "user/register";

  ///退出登录
  String logoutApi = "user/logout/json";

  ///登录
  Future<UserEntity> login(
      String account, String psw, HttpCanceler? canceler) async {
    //username，password
    Map<String, dynamic>? params = {"username": account, "password": psw};
    return await HttpRequest.post<UserEntity>(loginApi,
        params: params, canceler: canceler);
  }

  ///注册
  Future<UserEntity> register(String account, String psw, String confirmPsw,
      HttpCanceler? canceler) async {
    //username，password repassword
    Map<String, dynamic>? params = {
      "username": account,
      "password": psw,
      "repassword": confirmPsw
    };
    return await HttpRequest.post<UserEntity>(registerApi,
        params: params, canceler: canceler);
  }

  ///退出登录
  Future<UserEntity> logout(HttpCanceler? canceler) async {
    return await HttpRequest.post<UserEntity>(registerApi, canceler: canceler);
  }
}
