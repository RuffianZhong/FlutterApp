import 'package:flutter/material.dart';
import 'package:flutter_wan_android/core/net/cancel/zt_http_cancel.dart';
import 'package:flutter_wan_android/core/net/http_result.dart';
import 'package:flutter_wan_android/modules/article/model/article_entity.dart';
import 'package:flutter_wan_android/modules/project/model/project_model.dart';

class ProjectItemViewModel extends ChangeNotifier {
  ProjectModel model = ProjectModel();

  ///数据页面下标
  int pageIndex = 0;

  ///文章列表
  List<ArticleEntity> _articleList = [];

  List<ArticleEntity> get articleList => _articleList;

  set articleList(List<ArticleEntity> value) {
    _articleList = value;
    notifyListeners();
  }

  ///获取内容列表
  Future<HttpResult<ArticleEntity>> getArticleList(
      int projectId, bool refresh, HttpCanceler canceler) async {
    ///下拉刷新，下标从0开始
    if (refresh) pageIndex = 0;
    HttpResult<ArticleEntity> result =
        await model.getProjectList(projectId, pageIndex, canceler);
    if (result.success) {
      if (refresh) articleList.clear();
      articleList.addAll(result.list!);
      articleList = articleList;
      pageIndex++;
    }
    return result;
  }
}
