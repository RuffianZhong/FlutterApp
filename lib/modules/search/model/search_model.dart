import 'dart:io';

import 'package:flutter_wan_android/core/db/dao/search_dao.dart';
import 'package:flutter_wan_android/core/db/db_helper.dart';
import 'package:flutter_wan_android/core/net/http_request.dart';
import 'package:flutter_wan_android/modules/search/model/search_entity.dart';

import '../../../utils/log_util.dart';

///SearchModel
class SearchModel {
  late SqliteHelper helper;
  late SearchDao dao;

  SearchModel() {
    Logger.log("-----Model");
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

  ///获取服务器热门搜索词
  Future<List<SearchEntity>> getServerData() async {
    return await HttpRequest.get<List<SearchEntity>>(hotKeyApi);
  }

  void close() {
    helper.close();
  }
}
