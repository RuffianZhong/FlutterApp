import 'package:flutter/material.dart';
import 'package:flutter_wan_android/modules/main/model/article_entity.dart';

///ArticleDetailsViewModel
class ArticleDetailsViewModel extends ChangeNotifier {
  ///加载进度
  double _loadProgress = 0;

  double get loadProgress => _loadProgress;

  set loadProgress(double value) {
    _loadProgress = value;
    notifyListeners();
  }

  ///文章实体类
  ArticleEntity? _articleEntity;

  ArticleEntity? get articleEntity => _articleEntity;

  set articleEntity(ArticleEntity? value) {
    _articleEntity = value;
    notifyListeners();
  }
}
