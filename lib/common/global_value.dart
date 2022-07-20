import 'package:flutter_wan_android/utils/shared_preferences_utils.dart';

class GlobalValue {
  static const String spUid = "spUid";
  static const String spUser = "spUser";

  ///用户是否已经登录
  static Future<bool> isLogin() async {
    int? uid = await SPUtils.getInstance().getInt(spUid);
    return !(uid == null || uid <= 0);
  }

  ///设置登录状态
  ///uid==null || uid==0 未登录状态
  static void setLoginState(int uid) async {
    await SPUtils.getInstance().setInt(spUid, uid);
  }

  ///保存用户信息
  static void setUserJson(String userJson) async {
    await SPUtils.getInstance().setString(spUser, userJson);
  }

  ///获取用户信息
  static Future<String?> getUserJson() async {
    return await SPUtils.getInstance().getString(spUser);
  }
}
