import 'package:flutter/material.dart';
import 'package:flutter_lifecycle_aware/lifecycle_observer.dart';
import 'package:flutter_lifecycle_aware/lifecycle_owner.dart';
import 'package:flutter_lifecycle_aware/lifecycle_state.dart';
import 'package:flutter_wan_android/core/net/http_result.dart';
import 'package:flutter_wan_android/modules/article/model/article_entity.dart';
import 'package:flutter_wan_android/modules/home/model/banner_entity.dart';

import '../../../core/net/cancel/http_canceler.dart';
import '../model/home_model.dart';

class HomeViewModel extends ChangeNotifier with LifecycleObserver {
  ///HttpCanceler
  late HttpCanceler canceler;

  ///model
  late HomeModel model;

  HomeViewModel() {
    model = HomeModel();
  }

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

  ///置顶文章列表
  List<ArticleEntity> _articleTopList = [];

  List<ArticleEntity> get articleTopList => _articleTopList;

  set articleTopList(List<ArticleEntity> value) {
    _articleTopList = value;
    notifyListeners();
  }

  ///轮播图列表
  List<BannerEntity> _bannerList = [];

  List<BannerEntity> get bannerList => _bannerList;

  set bannerList(List<BannerEntity> value) {
    _bannerList = value;
    notifyListeners();
  }

  ///获取内容列表
  Future<HttpResult<ArticleEntity>> getArticleList(bool refresh) async {
    ///下拉刷新，下标从0开始
    if (refresh) pageIndex = 0;
    HttpResult<ArticleEntity> result =
        await model.getArticleList(pageIndex, canceler);
    if (result.success) {
      if (refresh) articleList.clear();
      articleList.addAll(result.list!);
      articleList = articleList;
      pageIndex++;
    }
    return result;
  }

  ///置顶文章
  Future<HttpResult<ArticleEntity>> getArticleTopList(
      bool refresh, HttpCanceler canceler) async {
    HttpResult<ArticleEntity> result = await model.getArticleTopList(canceler);
    if (result.success) {
      articleTopList = result.list ?? [];
    }
    return result;
  }

  @override
  void onLifecycleChanged(LifecycleOwner owner, LifecycleState state) {
    if (state == LifecycleState.onInit) {
      canceler = HttpCanceler(owner);
    } else if (state == LifecycleState.onCreate) {
      /// 首帧绘制完成
      /// 初始化数据
      getArticleList(true);
    }
  }
}
