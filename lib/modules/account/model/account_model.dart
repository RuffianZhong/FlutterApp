import 'dart:convert';

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
  Future<HttpResult> logout(HttpCanceler? canceler) async {
    ///结果
    Map<String, dynamic> value =
        await HttpRequest.get(logoutApi, canceler: canceler);

    return HttpResult().convert(value);
  }

  ///保存登录数据
  void saveUser(UserEntity entity) {
    GlobalValue.setLoginState(entity.uid ?? 0);
    GlobalValue.setUserJson(entity.toString());
  }

  ///获取账号信息
  Future<UserEntity> getUser() async {
    String? jsonStr = await GlobalValue.getUserJson();
    dynamic jsonMap = jsonDecode(jsonStr ?? "{}");
    return UserEntity.fromJson(jsonMap);
  }

  ///是否已经登录
  Future<bool> isLogin() async {
    return await GlobalValue.isLogin();
  }
}
