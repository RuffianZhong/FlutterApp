import 'package:flutter_wan_android/core/db/dao/search_dao.dart';
import 'package:flutter_wan_android/core/db/db_helper.dart';
import 'package:flutter_wan_android/core/net/http_request.dart';
import 'package:flutter_wan_android/modules/main/model/article_entity.dart';
import 'package:flutter_wan_android/modules/search/model/search_entity.dart';

import '../../../core/net/cancel/http_canceler.dart';
import '../../../core/net/http_result.dart';
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
  Future<HttpResult<SearchEntity>> getHotKeyFromServer() async {
    ///结果
    Map<String, dynamic> json = await HttpRequest.get(hotKeyApi);

    ///解析
    HttpResult<SearchEntity> result = HttpResult<SearchEntity>().convert(json);
    return result;
  }

  ///搜索内容
  Future<HttpResult<ArticleEntity>> getContentFromServer(
      String key, HttpCanceler? canceler) async {
    Map<String, dynamic>? params = {"k": key};

    ///结果
    Map<String, dynamic> json =
        await HttpRequest.post(searchApi, params: params, canceler: canceler);

    ///解析
    HttpResult<ArticleEntity> result =
        HttpResult<ArticleEntity>().convert(json);

    result.list = HttpResult.convertList<ArticleEntity>(json['data']["datas"]);
    return result;
  }

  void close() {
    helper.close();
  }
}
