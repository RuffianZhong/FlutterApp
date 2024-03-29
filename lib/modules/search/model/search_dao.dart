import 'package:flutter_wan_android/base/abs_dao.dart';
import 'package:sqflite/sqflite.dart';

import 'search_entity.dart';

///SearchDao
class SearchDao extends AbsDao {
  ///搜索表
  static const String tbSearch = "tb_search";

  ///搜索ID
  static const String fSearchId = "f_search_id";

  ///搜索值
  static const String fSearchValue = "f_search_value";

  ///搜索时间
  static const String fSearchTime = "f_search_time";

  ///创建表
  static void createTable(Database db) {
    ///创建搜索表
    String sql = '''
        create table $tbSearch(
        $fSearchId integer primary key autoincrement,
        $fSearchValue text not null,
        $fSearchTime integer not null)
        ''';

    db.execute(sql);
  }

  Future<SearchEntity> insertOrUpdate(String value, {int? id}) async {
    SearchEntity entity =
        SearchEntity(value: value, time: DateTime.now().millisecondsSinceEpoch);
    if (id == null) {
      entity.id = await helper.insert(tbSearch, toMap(entity));
    } else {
      await helper.update(tbSearch, toMap(entity),
          where: "$fSearchId=?", whereArgs: [id]);
    }
    return entity;
  }

  Future<int> delete({int? id}) async {
    return await helper.delete(tbSearch,
        where: id == null ? null : "$fSearchId=?",
        whereArgs: id == null ? null : [id]);
  }

  Future<List<SearchEntity>?> query() async {
    List<Map<String, Object?>>? list =
        await helper.query(tbSearch, orderBy: "$fSearchTime DESC");
    List<SearchEntity> entityList = [];
    if (list != null) {
      for (var item in list) {
        entityList.add(fromMap(item));
      }
    }

    return entityList;
  }

  SearchEntity fromMap(Map<String, Object?> map) {
    int id = map[fSearchId] as int;
    String value = map[fSearchValue] as String;
    int time = map[fSearchTime] as int;
    return SearchEntity(value: value, time: time, id: id);
  }

  Map<String, Object?> toMap(SearchEntity entity) {
    var map = <String, Object?>{
      fSearchValue: entity.value,
      fSearchTime: entity.time
    };
    if (entity.id != null) {
      map[fSearchId] = entity.id;
    }
    return map;
  }
}
