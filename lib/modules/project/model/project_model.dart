import 'package:flutter_wan_android/core/net/cancel/http_canceler.dart';
import 'package:flutter_wan_android/core/net/http_result.dart';
import 'package:flutter_wan_android/modules/article/model/article_entity.dart';
import 'package:flutter_wan_android/modules/project/model/category_entity.dart';

import '../../../core/net/http_request.dart';

class ProjectModel {
  ///项目分类
  final String projectTreeApi = "project/tree/json";

  ///项目列表数据
  final String projectListApi = "project/list/%1/json?cid=%2";

  ///获取项目分配
  Future<HttpResult<CategoryEntity>> getProjectTree(
      {HttpCanceler? canceler}) async {
    ///结果
    Map<String, dynamic> json =
        await HttpRequest.get(projectTreeApi, canceler: canceler);

    ///解析
    HttpResult<CategoryEntity> result =
        HttpResult<CategoryEntity>().convert(json);

    return result;
  }

  ///获取项目列表
  ///projectId：项目分类ID
  Future<HttpResult<ArticleEntity>> getProjectList(
      int projectId, int pageIndex, HttpCanceler canceler) async {
    String api = projectListApi.replaceAll('%1', pageIndex.toString());
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
