import 'package:flutter/material.dart';

import '../../../core/lifecycle/widget_lifecycle_owner.dart';
import '../../../core/net/cancel/http_canceler.dart';
import '../model/category_entity.dart';
import '../model/project_model.dart';

class ProjectViewModel extends ChangeNotifier {
  ProjectModel model = ProjectModel();

  ///项目分类列表
  List<CategoryEntity> _projectList = [];

  List<CategoryEntity> get projectList => _projectList;

  set projectList(List<CategoryEntity> value) {
    _projectList = value;
    notifyListeners();
  }

  void getProjectTree(WidgetLifecycleOwner lifecycleOwner) {
    model.getProjectTree(HttpCanceler(lifecycleOwner)).then((value) {
      if (value.success) {
        projectList = value.list!;
      }
    });
  }
}
