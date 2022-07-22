import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter_wan_android/core/net/http_config.dart';
import 'package:path_provider/path_provider.dart';

///网络请求Cookie辅助类
class CookieHelper {
  ///持久化到文件的cookie
  static PersistCookieJar? _cookieJar;

  static Future<PersistCookieJar> get cookieJar async {
    if (_cookieJar == null) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;

      _cookieJar = PersistCookieJar(
          ignoreExpires: true, storage: FileStorage("$appDocPath/.cookies/"));
    }

    return _cookieJar!;
  }

  ///保存cookie
  static void saveCookie(Map<String, String> json) async {
    /*   List<Cookie> cookies = [
      Cookie("userLoginName", "zhong01"),
      Cookie("userLoginPassword", "test12345"),
    ];*/

    List<Cookie> cookies = [];
    json.forEach((key, value) {
      cookies.add(Cookie(key, value));
    });
    (await cookieJar).saveFromResponse(Uri.parse(HttpConfig.baseUrl), cookies);
  }

  ///获取cookie
  static Future<List<Cookie>> getCookie() async {
    List<Cookie> cookies =
        await (await cookieJar).loadForRequest(Uri.parse(HttpConfig.baseUrl));
    return cookies;
  }
}
