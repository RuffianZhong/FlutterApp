import 'package:flutter_wan_android/modules/book/model/study_entity.dart';
import 'package:sqflite/sqflite.dart';

import '../../../base/abs_dao.dart';

///StudyDao
class StudyDao extends AbsDao {
  ///表
  static const String tbBookStudy = "tb_book_study";

  ///表ID
  static const String fBookStudyId = "f_book_study_id";

  ///教程ID
  static const String fBookId = "f_book_id";

  ///文章ID：章节ID
  static const String fArticleId = "f_article_id";

  ///学习进度
  static const String fStudyProgress = "f_study_progress";

  ///学习时间
  static const String fStudyTime = "f_study_time";

  ///创建表
  static void createTable(Database db) {
    ///创建搜索表
    String sql = '''
        create table $tbBookStudy(
        $fBookStudyId integer primary key autoincrement,
        $fBookId integer not null,
        $fArticleId integer not null,
        $fStudyProgress real not null,
        $fStudyTime integer not null)
        ''';

    db.execute(sql);
  }

  ///插入数据或者更新数据
  /// id ==null 插入数据
  Future<StudyEntity> insertOrUpdate(
      {int? id,
      required int bookId,
      required int articleId,
      required double progress}) async {
    StudyEntity entity = StudyEntity(
        id: id,
        bookId: bookId,
        articleId: articleId,
        progress: progress,
        time: DateTime.now().millisecondsSinceEpoch);

    if (id == null) {
      entity.id = await helper.insert(tbBookStudy, toMap(entity));
    } else {
      await helper.update(tbBookStudy, toMap(entity),
          where: "$fBookStudyId=?", whereArgs: [id]);
    }
    return entity;
  }

  ///删除数据
  ///id == null 删除全部
  Future<int> delete({int? id}) async {
    return await helper.delete(tbBookStudy,
        where: id == null ? null : "$fBookStudyId=?",
        whereArgs: id == null ? null : [id]);
  }

  ///按照书本 查询数据
  ///bookId：教程ID
  Future<List<StudyEntity>> query(int bookId) async {
    List<Map<String, Object?>>? list = await helper
        .query(tbBookStudy, where: "$fBookId=?", whereArgs: [bookId]);
    List<StudyEntity> entityList = [];
    if (list != null) {
      for (var item in list) {
        entityList.add(fromMap(item));
      }
    }

    return entityList;
  }

  StudyEntity fromMap(Map<String, Object?> map) {
    int id = map[fBookStudyId] as int;
    int bookId = map[fBookId] as int;
    int articleId = map[fArticleId] as int;
    double progress = map[fStudyProgress] as double;
    int time = map[fStudyTime] as int;

    return StudyEntity(
        id: id,
        bookId: bookId,
        articleId: articleId,
        progress: progress,
        time: time);
  }

  Map<String, Object?> toMap(StudyEntity entity) {
    var map = <String, Object?>{
      fBookId: entity.bookId,
      fArticleId: entity.articleId,
      fStudyProgress: entity.progress,
      fStudyTime: entity.time,
    };
    if (entity.id != null) {
      map[fBookStudyId] = entity.id;
    }
    return map;
  }
}
