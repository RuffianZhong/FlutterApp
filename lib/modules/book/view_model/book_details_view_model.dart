import 'package:flutter/material.dart';
import 'package:flutter_wan_android/modules/article/model/article_entity.dart';

import '../../../core/lifecycle/zt_lifecycle.dart';
import '../../../core/net/cancel/http_canceler.dart';
import '../../../core/net/http_result.dart';
import '../model/book_model.dart';
import '../model/study_entity.dart';

class BookDetailsViewModel extends ChangeNotifier with WidgetLifecycleObserver {
  @override
  void onStateChanged(WidgetLifecycleOwner owner, WidgetLifecycleState state) {
    if (state == WidgetLifecycleState.onDestroy) {
      model.close();
    }
  }

  BookModel model = BookModel();

  ///文章列表
  List<ArticleEntity> _articleList = [];

  List<ArticleEntity> get articleList => _articleList;

  set articleList(List<ArticleEntity> value) {
    _articleList = value;
    notifyListeners();
  }

  ///获取内容列表
  Future<HttpResult<ArticleEntity>> getArticleList(
      int projectId, HttpCanceler canceler) async {
    HttpResult<ArticleEntity> result =
        await model.getBookArticleList(projectId, 0, canceler);
    if (result.success) {
      _articleList.addAll(result.list!);
    }
    return result;
  }

  ///学习进度列表
  List<StudyEntity> _studyList = [];

  ///获取学习列表数据：本地数据库
  Future<List<StudyEntity>> getStudyListData(int bookId) async {
    _studyList = await model.dao.query(bookId);
    return _studyList;
  }

  ///初始化数据
  void initData(int projectId, WidgetLifecycleOwner owner) {
    ///多个 future
    Iterable<Future> futures = [
      getArticleList(projectId, HttpCanceler(owner)),
      getStudyListData(projectId)
    ];

    ///等待多个 future 执行完成
    Future.wait(futures).then((value) {
      updateStudyData(_studyList, _articleList);
    });
  }

  ///更新列表学习数据
  void updateStudyData(
      List<StudyEntity> studyList, List<ArticleEntity> articleList) {
    if (studyList.isNotEmpty && articleList.isNotEmpty) {
      StudyEntity study;
      ArticleEntity article;

      ///遍历学习进度列表
      for (int i = 0; i < studyList.length; i++) {
        study = studyList[i];

        ///遍历文章（章节列表）
        for (int j = 0; j < articleList.length; j++) {
          article = articleList[j];

          ///匹配/更新学习进度
          if (article.id == study.articleId) {
            article.study = study;
            articleList[j] = article;
            break;
          }
        }
      }
    }

    ///更新viewModel数据
    this.articleList = articleList;
  }

  ///插入或者更新数据
  Future<StudyEntity> insertOrUpdateStudy(
      int bookId, int articleId, double progress,
      {int? id}) async {
    StudyEntity study =
        await model.insertOrUpdateStudy(id: id, bookId, articleId, progress);

    updateStudyData([study], _articleList);

    return study;
  }
}
