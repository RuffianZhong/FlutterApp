import 'package:flutter_wan_android/utils/shared_preferences_utils.dart';

class GlobalValue {
  static const String spUid = "spUid";
  static const String spUAccount = "spUAccount";

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

  ///保存用户账号
  static void setUserAccount(String account) async {
    await SPUtils.getInstance().setString(spUAccount, account);
  }

  ///获取用户账号
  static Future<String?> getUserAccount() async {
    return await SPUtils.getInstance().getString(spUAccount);
  }
}
