import 'package:flutter_wan_android/core/db/dao/search_dao.dart';
import 'package:flutter_wan_android/core/db/db_helper.dart';
import 'package:flutter_wan_android/core/net/http_request.dart';
import 'package:flutter_wan_android/modules/search/model/search_entity.dart';

import '../../../core/net/cancel/http_canceler.dart';
import '../../main/model/article_rsp_entity.dart';

///SearchModel
class SearchModel {
  late SqliteHelper helper;
  late SearchDao dao;

  SearchModel() {
    helper = SqliteHelper();
    dao = SearchDao();
  }

  ///获取本地数据
  Future<List<SearchEntity>?> getLocalData() async {
    return await dao.query(helper);
  }

  ///删除本地数据
  Future<int> deleteLocalData({int? id}) async {
    return dao.delete(helper, id: id);
  }

  ///新增或者更新数据
  Future<SearchEntity> insertOrUpdateLocalData(String value, {int? id}) async {
    return await dao.insertOrUpdate(helper, value, id: id);
  }

  ///热门搜索API
  String hotKeyApi = "/hotkey/json";

  ///搜索内容API
  String searchApi = "/article/query/0/json";

  ///获取服务器热门搜索词
  Future<List<SearchEntity>> getHotKeyFromServer() async {
    return await HttpRequest.get<List<SearchEntity>>(hotKeyApi);
  }

  ///搜索内容
  Future<ArticleRspEntity> getContentFromServer(
      String key, HttpCanceler? canceler) async {
    Map<String, dynamic>? params = {"k": key};
    return await HttpRequest.post<ArticleRspEntity>(searchApi,
        params: params, canceler: canceler);
  }

  void close() {
    helper.close();
  }
}
