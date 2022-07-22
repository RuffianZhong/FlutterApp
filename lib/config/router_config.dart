import 'package:flutter/material.dart';
import 'package:flutter_wan_android/modules/details/view/article_details_page.dart';
import 'package:flutter_wan_android/modules/main/view/collection_list_page.dart';
import 'package:flutter_wan_android/modules/main/view/knowledge_child_page.dart';

import '../modules/account/view/login_page.dart';
import '../modules/account/view/register_page.dart';
import '../modules/search/view/search_page.dart';

///路由配置
class RouterConfig {
  ///搜索页面
  static const String searchPage = "searchPage";

  ///内容页面
  static const String articleDetailsPage = "articleDetailsPage";

  ///登录页面
  static const String loginPage = "loginPage";

  ///注册页面
  static const String registerPage = "registerPage";

  ///知识体系二级界面
  static const String knowledgeChildPage = "knowledgeChildPage";

  ///收藏列表页面
  static const String collectListPage = "collectListPage";

  ///路由表配置
  static Map<String, WidgetBuilder> routes = {
    searchPage: (context) => const SearchPage(),
    articleDetailsPage: (context) => const ArticleDetailsPage(),
    loginPage: (context) => const LoginPage(),
    registerPage: (context) => const RegisterPage(),
    knowledgeChildPage: (context) => const KnowledgeChildPage(),
    collectListPage: (context) => const CollectionListPage(),
  };
}
