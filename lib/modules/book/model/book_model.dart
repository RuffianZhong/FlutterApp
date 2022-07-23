import 'package:flutter_wan_android/modules/book/model/study_dao.dart';
import 'package:flutter_wan_android/modules/book/model/study_entity.dart';
import 'package:flutter_wan_android/modules/main/model/knowledge_model.dart';

import '../../../core/net/cancel/http_canceler.dart';
import '../../../core/net/http_request.dart';
import '../../../core/net/http_result.dart';
import '../../main/model/article_entity.dart';
import 'book_entity.dart';

class BookModel {
  ///教程列表
  final String bookListApi = "chapter/547/sublist/json";

  ///获取教程列表f
  Future<HttpResult<BookEntity>> getBookList(HttpCanceler? canceler) async {
    ///结果
    Map<String, dynamic> json =
        await HttpRequest.get(bookListApi, canceler: canceler);

    ///解析
    HttpResult<BookEntity> result = HttpResult<BookEntity>().convert(json);

    return result;
  }

  ///获取项目列表
  ///projectId：项目分类ID
  Future<HttpResult<ArticleEntity>> getBookArticleList(
      int projectId, int pageIndex, HttpCanceler canceler) async {
    ///逻辑与获取分类下文章一致，直接复用

    KnowledgeModel model = KnowledgeModel();
    return model.getCategoryArticleList(projectId, pageIndex, canceler);
  }

  late StudyDao dao;

  BookModel() {
    dao = StudyDao();
  }

  void close() {
    dao.close();
  }

  ///插入或更新数据
  Future<StudyEntity> insertOrUpdateStudy(
      int bookId, int articleId, double progress,
      {int? id}) async {
    return dao.insertOrUpdate(
        id: id, bookId: bookId, articleId: articleId, progress: progress);
  }

  ///获取学习数据
  Future<List<StudyEntity>?> getStudyList(int bookId) async {
    return dao.query(bookId);
  }
}
