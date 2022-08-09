import 'package:flutter_wan_android/modules/article/model/article_entity.dart';

import '../../../core/net/cancel/http_canceler.dart';
import '../../../core/net/http_request.dart';
import '../../../core/net/http_result.dart';

class CollectModel {
  ///收藏列表
  final String collectListApi = "lg/collect/list/%1/json";

  ///收藏文章
  final String collectArticleApi = "lg/collect/%1/json";

  ///取消收藏

  final String unCollectArticleApi = "lg/uncollect_originId/%1/json";

  ///获取收藏文章列表
  Future<HttpResult<ArticleEntity>> getCollectList(
      int pageIndex, HttpCanceler canceler) async {
    ///参数
    String api = collectListApi.replaceAll("%1", pageIndex.toString());

    ///结果
    Map<String, dynamic> json = await HttpRequest.get(api, canceler: canceler);

    ///解析
    HttpResult<ArticleEntity> result =
        HttpResult<ArticleEntity>().convert(json);

    if (result.success) {
      result.list =
          HttpResult.convertList<ArticleEntity>(json['data']["datas"]);
      for (ArticleEntity entity in result.list!) {
        ///收藏列表默认都是已经收藏的文章
        entity.collect = true;
      }
    }

    return result;
  }

  ///收藏或取消文章
  Future<HttpResult> collectOrCancelArticle(int articleId, bool collect,
      {HttpCanceler? canceler}) async {
    ///参数
    String api = collect ? collectArticleApi : unCollectArticleApi;

    api = api.replaceAll("%1", articleId.toString());

    ///结果
    Map<String, dynamic> json = await HttpRequest.post(api, canceler: canceler);

    ///解析
    HttpResult result = HttpResult().convert(json);

    return result;
  }
}
