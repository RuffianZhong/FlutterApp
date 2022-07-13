import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_wan_android/utils/log_util.dart';

import '../generated/json/base/json_convert_content.dart';

///路由辅助类
class RouterHelper {
  // 从Navigator中移除当前所在路由再跳转到新的路由，相当于finish再startActivity
  // Navigator.popAndPushNamed
  // // 根据指定的Route直接返回，在此之前的路由会被清除
  // Navigator.popUntil
  // // 跳转到新的Route，并将指定Route之前的的Route清空，pushNamedAndRemoveUntil与之类似
  // Navigator.pushAndRemoveUntil
  // // 页面替换，pushReplacementNamed与之类似
  // Navigator.pushReplacement

  /// Map<String, dynamic> routeParams =
  //         ModalRoute.of(context).settings?.arguments;
  ///

  ///直接传递页面进行导航
  static Future<T?> push<T extends Object?>(
      BuildContext context, Widget widget) {
    return Navigator.push(context, MaterialPageRoute(builder: (context) {
      return widget;
    }));
  }

  ///根据路由名称导航
  ///需要在 MaterialApp 中添加路由表
  ///  return MaterialApp(
  ///       routes: <String, WidgetBuilder>{
  ///         // xx 名称对应 xxPage 页面
  ///         "xxName": (BuildContext context) => xxPage(),
  ///       },
  ///     );
  static Future<T?> pushNamed<T extends Object?>(
      BuildContext context, String routeName,
      {Object? arguments}) {
    return Navigator.pushNamed(context, routeName, arguments: arguments);
  }

  ///关闭页面
  static void pop<T extends Object?>(BuildContext context, [T? result]) {
    Navigator.pop(context, result);
  }

  ///获取参数：map
  static Map<String, dynamic> argumentsMap(BuildContext context) {
    Map<String, dynamic> map = {};

    Object? object = ModalRoute.of(context)?.settings.arguments;
    if (object != null) {
      try {
        map = json.decode(json.encode(object));
      } catch (e) {
        Logger.log(e);
      }
    }
    return map;
  }

  ///获取参数：实体类
  static T? argumentsEntity<T>(BuildContext context) {
    T? entity = jsonConvert.convert<T>(argumentsMap(context));
    return entity;
  }

  ///获取参数：T
  static T? argumentsT<T>(BuildContext context) {
    Object? object = ModalRoute.of(context)?.settings.arguments;
    if (object == null) return null;
    return object as T;
  }
}
