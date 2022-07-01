import 'package:flutter/cupertino.dart';

/// Widget 路由观察者
/// 辅助监听 RouteAware
/// 需要在 MaterialApp 中添加
///     return MaterialApp(
///       navigatorObservers: [WidgetRouteObserver.routeObserver]
///     );
class WidgetRouteObserver {
  static final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
}
