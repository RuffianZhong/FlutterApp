import 'package:flutter/material.dart';
import 'package:flutter_wan_android/modules/details/view/article_details_page.dart';

import '../modules/search/view/search_page.dart';

///路由配置
class RouteConfig {
  ///搜索页面
  static const String searchPage = "search_page";

  ///内容页面
  static const String articleDetailsPage = "article_details_page";

  ///路由表配置
  static Map<String, WidgetBuilder> routes = {
    searchPage: (context) => const SearchPage(),
    articleDetailsPage: (context) => const ArticleDetailsPage()
  };
}
