import 'package:flutter/material.dart';

import '../modules/search/view/search_page.dart';

///路由配置
class RouteConfig {
  ///搜索页面
  static const String searchPage = "search_page";

  ///路由表配置
  static Map<String, WidgetBuilder> routes = {
    searchPage: (context) => const SearchPage(),
  };
}
