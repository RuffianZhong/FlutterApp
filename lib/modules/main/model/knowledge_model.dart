import 'package:flutter_wan_android/modules/main/model/nav_entity.dart';

import '../../../core/net/cancel/http_canceler.dart';
import '../../../core/net/http_request.dart';
import '../../../core/net/http_result.dart';
import 'article_entity.dart';
import 'category_entity.dart';

class KnowledgeModel {
  ///体系列表
  final String systemListApi = "tree/json";

  ///导航列表
  final String navListApi = "navi/json";

  ///分类下文章列表
  final String categoryArticleListApi = "article/list/%1/json?cid=%2";

  ///获取体系分类列表
  Future<HttpResult<CategoryEntity>> getSystemList(
      HttpCanceler? canceler) async {
    ///结果
    Map<String, dynamic> json =
        await HttpRequest.get(systemListApi, canceler: canceler);

    ///解析
    HttpResult<CategoryEntity> result =
        HttpResult<CategoryEntity>().convert(json);

    return result;
  }

  ///获取导航分类列表
  Future<HttpResult<NavEntity>> getNavList(HttpCanceler? canceler) async {
    ///结果
    Map<String, dynamic> json =
        await HttpRequest.get(navListApi, canceler: canceler);

    ///解析
    HttpResult<NavEntity> result = HttpResult<NavEntity>().convert(json);

    return result;
  }

  ///获取项目列表
  ///projectId：项目分类ID
  Future<HttpResult<ArticleEntity>> getCategoryArticleList(
      int projectId, int pageIndex, HttpCanceler canceler) async {
    String api = categoryArticleListApi.replaceAll('%1', pageIndex.toString());
    api = api.replaceAll('%2', projectId.toString());

    ///结果
    Map<String, dynamic> json = await HttpRequest.get(api, canceler: canceler);

    ///解析
    HttpResult<ArticleEntity> result =
        HttpResult<ArticleEntity>().convert(json);

    result.list = HttpResult.convertList<ArticleEntity>(json['data']["datas"]);

    return result;
  }
}
