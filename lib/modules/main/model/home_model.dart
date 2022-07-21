import 'package:flutter_wan_android/core/net/http_result.dart';
import 'package:flutter_wan_android/modules/main/model/article_entity.dart';
import 'package:flutter_wan_android/modules/main/model/banner_entity.dart';

import '../../../core/net/cancel/http_canceler.dart';
import '../../../core/net/http_request.dart';

class HomeModel {
  ///文章列表
  final String articleListApi = "article/list/0/json";

  ///置顶文章列表
  final String articleTopListApi = "article/top/json";

  ///轮播图
  final String bannerListApi = "banner/json";

  ///获取文章列表
  Future<HttpResult<ArticleEntity>> getArticleList(
      int pageIndex, HttpCanceler? canceler) async {
    ///参数
    String api = articleListApi.replaceAll("0", pageIndex.toString());

    ///结果
    Map<String, dynamic> json = await HttpRequest.get(api, canceler: canceler);

    ///解析
    HttpResult<ArticleEntity> result =
        HttpResult<ArticleEntity>().convert(json);

    result.list = HttpResult.convertList<ArticleEntity>(json['data']["datas"]);

    return result;
  }

  ///获取轮播图列表
  Future<HttpResult<BannerEntity>> getBannerList(HttpCanceler? canceler) async {
    ///结果
    Map<String, dynamic> json =
        await HttpRequest.get(bannerListApi, canceler: canceler);

    ///解析
    HttpResult<BannerEntity> result = HttpResult<BannerEntity>().convert(json);

    return result;
  }

  ///获取置顶文章列表
  Future<HttpResult<ArticleEntity>> getArticleTopList(
      HttpCanceler? canceler) async {
    ///结果
    Map<String, dynamic> json =
        await HttpRequest.get(articleTopListApi, canceler: canceler);

    ///解析
    HttpResult<ArticleEntity> result =
        HttpResult<ArticleEntity>().convert(json);

    List<ArticleEntity> list = result.list!;
    ArticleEntity entity;
    for (int i = 0; i < list.length; i++) {
      entity = list[i];
      entity.isTop = true; //置顶
      list[i] = entity;
    }

    result.list = list;

    return result;
  }
}
