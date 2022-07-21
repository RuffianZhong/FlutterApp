import 'package:flutter/material.dart';

import '../../../core/lifecycle/widget_lifecycle_owner.dart';
import '../../../core/net/cancel/http_canceler.dart';
import '../model/knowledge_entity.dart';
import '../model/knowledge_model.dart';

class KnowledgeViewModel extends ChangeNotifier {
  KnowledgeModel model = KnowledgeModel();

  ///知识实体类
  KnowledgeEntity _entity = KnowledgeEntity();

  KnowledgeEntity get entity => _entity;

  set entity(KnowledgeEntity value) {
    _entity = value;
    notifyListeners();
  }

  ///获取分类列表
  void getCategoryList(WidgetLifecycleOwner owner) {
    model.getSystemList(HttpCanceler(owner)).then((value) {
      if (value.success) {
        entity.categoryList = value.list!;
        entity = entity;
      }
    });
  }

  ///获取导航列表
  void getNavList(WidgetLifecycleOwner owner) {
    model.getNavList(HttpCanceler(owner)).then((value) {
      if (value.success) {
        entity.navList = value.list!;
        entity = entity;
      }
    });
  }
}
