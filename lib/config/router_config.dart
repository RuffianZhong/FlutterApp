import 'package:flutter/material.dart';
import 'package:flutter_wan_android/modules/account/view/login_page.dart';
import 'package:flutter_wan_android/modules/account/view/register_page.dart';
import 'package:flutter_wan_android/modules/article/view/article_details_page.dart';
import 'package:flutter_wan_android/modules/book/view/book_details_page.dart';
import 'package:flutter_wan_android/modules/collect/view/collection_list_page.dart';
import 'package:flutter_wan_android/modules/knowledge/view/knowledge_child_page.dart';
import 'package:flutter_wan_android/modules/search/view/search_page.dart';

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

  ///教程详情页面
  static const String bookDetailsPage = "bookDetailsPage";

  ///路由表配置
  static Map<String, WidgetBuilder> routes = {
    searchPage: (context) => const SearchPage(),
    articleDetailsPage: (context) => const ArticleDetailsPage(),
    loginPage: (context) => const LoginPage(),
    registerPage: (context) => const RegisterPage(),
    knowledgeChildPage: (context) => const KnowledgeChildPage(),
    collectListPage: (context) => const CollectionListPage(),
    bookDetailsPage: (context) => const BookDetailsPage(),
  };
}
