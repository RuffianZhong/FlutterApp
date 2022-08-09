import 'package:flutter/material.dart';
import 'package:flutter_lifecycle_aware/lifecycle_owner.dart';
import 'package:flutter_wan_android/core/net/cancel/http_canceler.dart';
import 'package:flutter_wan_android/modules/knowledge/model/knowledge_entity.dart';
import 'package:flutter_wan_android/modules/knowledge/model/knowledge_model.dart';

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
  void getCategoryList(HttpCanceler canceler) {
    model.getSystemList(canceler).then((value) {
      if (value.success) {
        entity.categoryList = value.list!;
        entity = entity;
      }
    });
  }

  ///获取导航列表
  void getNavList(HttpCanceler canceler) {
    model.getNavList(canceler).then((value) {
      if (value.success) {
        entity.navList = value.list!;
        entity = entity;
      }
    });
  }
}
