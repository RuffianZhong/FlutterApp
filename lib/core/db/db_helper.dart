import 'package:flutter_wan_android/modules/book/model/study_dao.dart';
import 'package:sqflite/sqflite.dart';

import '../../modules/search/model/search_dao.dart';

///数据库辅助类
class SqliteHelper {
  Database? _database;

  ///数据库路径/名称
  final String path = "zt_com_flutter.db";

  ///数据库版本
  final int version = 1;

  ///打开数据库
  Future<Database> get database async {
    _database ??= await openDatabase(
      path, version: version,

      ///数据库创建
      onCreate: (Database db, int version) {
        SearchDao.createTable(db);
        StudyDao.createTable(db);
      },

      ///数据库升级
      onUpgrade: (Database db, int oldVersion, int newVersion) {
        switch (newVersion) {
          case 2:
            break;
        }
      },
    );

    return _database!;
  }

  ///关闭数据库
  void close() async {
    (await database).close();
  }

  ///插入数据
  Future<int> insert(String table, Map<String, Object?> values) async {
    return await (await database).insert(table, values);
  }

  ///删除数据
  Future<int> delete(String table,
      {String? where, List<Object?>? whereArgs}) async {
    return await (await database)
        .delete(table, where: where, whereArgs: whereArgs);
  }

  ///更新数据
  Future<int> update(String table, Map<String, Object?> values,
      {String? where, List<Object?>? whereArgs}) async {
    return (await database)
        .update(table, values, where: where, whereArgs: whereArgs);
  }

  ///查询数据
  Future<List<Map<String, Object?>>?> query(String table,
      {List<String>? columns,
      String? where,
      List<Object?>? whereArgs,
      String? groupBy,
      String? having,
      String? orderBy,
      int? limit,
      int? offset}) async {
    List<Map<String, Object?>> list = await (await database).query(table,
        columns: columns,
        where: where,
        whereArgs: whereArgs,
        groupBy: groupBy,
        having: having,
        orderBy: orderBy,
        limit: limit,
        offset: offset);

    return list;
  }
}
