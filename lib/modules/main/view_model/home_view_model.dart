import 'package:flutter/material.dart';

import '../../../core/lifecycle/zt_lifecycle.dart';
import '../../../core/net/cancel/http_canceler.dart';
import '../model/article_entity.dart';
import '../model/home_model.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel() {
    model = HomeModel();
  }

  ///model
  late HomeModel model;

  ///快速回到顶部
  bool _quickToTop = false;

  bool get quickToTop => _quickToTop;

  set quickToTop(bool value) {
    _quickToTop = value;
    notifyListeners();
  }

  ///数据页面下标
  int pageIndex = 0;

  ///文章列表
  List<ArticleEntity> _articleList = [];

  List<ArticleEntity> get articleList => _articleList;

  set articleList(List<ArticleEntity> value) {
    _articleList = value;
    notifyListeners();
  }

  ///搜索内容
  void getContentFromServer(
      int pageIndex, WidgetLifecycleOwner lifecycleOwner) {
    model
        .getArticleListFromServer(pageIndex, HttpCanceler(lifecycleOwner))
        .then((value) {
      articleList = value.datas;
      pageIndex++;
    });
  }
}
