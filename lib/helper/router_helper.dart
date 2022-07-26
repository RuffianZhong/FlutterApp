import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_wan_android/utils/log_util.dart';

///路由辅助类
///Navigator.push/pushXX<T> 定义 T 会报错，此处去除泛型定义，直接只用 dynamic
class RouterHelper {
  ///参考一下： https://blog.csdn.net/kk_yanwu/article/details/116030668

  ///remove移除路由：待实现

  /// 根据路由名称导航
  /// 需要在 MaterialApp 中添加路由表
  ///  return MaterialApp(
  ///       routes: <String, WidgetBuilder>{
  ///         // xx 名称对应 xxPage 页面
  ///         "xxName": (BuildContext context) => xxPage(),
  ///       },
  ///     );

  ///直接传递页面进行导航
  static Future push(BuildContext context, Widget widget,
      {bool fullscreenDialog = false}) {
    return Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return widget;
          },

          /// 全屏弹窗效果，从下往上出现
          fullscreenDialog: fullscreenDialog,
        ));
  }

  ///根据路由名称导航
  static Future pushNamed(BuildContext context, String routeName,
      {Object? arguments}) {
    ///此处定义强类型会报错
    return Navigator.pushNamed(context, routeName, arguments: arguments);
  }

  ///替换栈顶(当前)页面
  static Future pushReplacementNamed(BuildContext context, String routeName,
      {Object? arguments}) {
    return Navigator.pushReplacementNamed(context, routeName,
        arguments: arguments);
  }

  ///跳转到页面移除其他所有界面（除了指定的页面）
  ///说明：当前栈情况：p1=>p2=>p3=>p4  目标界面 routeName = p9  保留界面 p2
  ///执行之后移除 p1=>p3=>p4 只剩下 p1 以及新增加的 p9
  static Future pushNamedAndRemoveUntil(
      BuildContext context, String routeName, String? untilName,
      {Object? arguments}) {
    /// predicate = false 全部不移除
    /// predicate = true 全部移除
    /// predicate = ModalRoute.withName(untilName); 指定保留页面
    RoutePredicate predicate;
    if (untilName == null || untilName.isEmpty) {
      predicate = (Route<dynamic> route) => false;
    } else {
      predicate = ModalRoute.withName(untilName);
    }

    return Navigator.pushNamedAndRemoveUntil(context, routeName, predicate,
        arguments: arguments);
  }

  ///从当前开始关闭页面，一直返回到目标页面
  ///说明：当前栈情况：p1=>p2=>p3=>p4  回到目标界面 untilName = p1
  ///执行之后移除 p2=>p3=>p4 只剩下 p1
  static void popUntil(BuildContext context, String? untilName) {
    RoutePredicate predicate;

    ///untilName = null 直接回到首页
    if (untilName == null || untilName.isEmpty) {
      predicate = (Route<dynamic> route) {
        return route.isFirst;
      };
    } else {
      predicate = ModalRoute.withName(untilName);
    }
    Navigator.popUntil(context, predicate);
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

  ///获取参数：T
  ///传递参数时明确传递了某个 T 值
  static T? argumentsT<T>(BuildContext context) {
    Object? object = ModalRoute.of(context)?.settings.arguments;
    if (object == null) return null;
    return object as T;
  }
}
