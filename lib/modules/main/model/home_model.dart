import '../../../core/net/cancel/http_canceler.dart';
import '../../../core/net/http_request.dart';
import 'article_rsp_entity.dart';

class HomeModel {
  ///文章列表
  String articleListApi = "/article/list/0/json";

  ///获取文章列表
  Future<ArticleRspEntity> getArticleListFromServer(
      int pageIndex, HttpCanceler? canceler) async {
    articleListApi = articleListApi.replaceAll("0", pageIndex.toString());
    return await HttpRequest.get<ArticleRspEntity>(articleListApi,
        canceler: canceler);
  }
}
