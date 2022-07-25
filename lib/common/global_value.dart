import 'package:flutter_wan_android/utils/shared_preferences_utils.dart';

class GlobalValue {
  ///用户信息
  static const String spUid = "spUid";
  static const String spUser = "spUser";

  ///本地化
  static const String spLocal = "spLocal";

  ///主题
  static const String spTheme = "spTheme";

  ///暗黑模式
  static const String spDarkMode = "spDarkMode";

  ///用户是否已经登录
  static Future<bool> isLogin() async {
    int? uid = await SpUtil.getInstance().getInt(spUid);
    return !(uid == null || uid <= 0);
  }

  ///设置登录状态
  ///uid==null || uid==0 未登录状态
  static void setLoginState(int uid) async {
    await SpUtil.getInstance().setInt(spUid, uid);
  }

  ///保存用户信息
  static void setUserJson(String userJson) async {
    await SpUtil.getInstance().setString(spUser, userJson);
  }

  ///获取用户信息
  static Future<String?> getUserJson() async {
    return await SpUtil.getInstance().getString(spUser);
  }

  ///存储local
  static Future<bool> setLocalIndex(int localIndex) async {
    return await SpUtil.getInstance().setInt(spLocal, localIndex);
  }

  ///获取local
  static Future<int?> getLocalIndex() async {
    return await SpUtil.getInstance().getInt(spLocal);
  }

  ///存储theme
  static Future<bool> setThemeIndex(int themeIndex) async {
    return await SpUtil.getInstance().setInt(spTheme, themeIndex);
  }

  ///获取theme
  static Future<int?> getThemeIndex() async {
    return await SpUtil.getInstance().getInt(spTheme);
  }

  ///存储暗黑模式
  static Future<bool> setDarkMode(bool darkModel) async {
    return await SpUtil.getInstance().setBool(spDarkMode, darkModel);
  }

  ///获取暗黑模式
  static Future<bool?> getDarkMode() async {
    return await SpUtil.getInstance().getBool(spDarkMode);
  }
}
