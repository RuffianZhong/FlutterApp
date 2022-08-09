import 'package:flutter/material.dart';
import 'package:flutter_lifecycle_aware/lifecycle_observer.dart';
import 'package:flutter_lifecycle_aware/lifecycle_owner.dart';
import 'package:flutter_lifecycle_aware/lifecycle_state.dart';
import 'package:flutter_wan_android/modules/project/model/category_entity.dart';
import 'package:flutter_wan_android/modules/project/model/project_model.dart';

import '../../../core/net/cancel/http_canceler.dart';

class ProjectViewModel extends ChangeNotifier with LifecycleObserver {
  late HttpCanceler httpCanceler;
  ProjectModel model = ProjectModel();

  ///项目分类列表
  List<CategoryEntity> _projectList = [];

  List<CategoryEntity> get projectList => _projectList;

  set projectList(List<CategoryEntity> value) {
    _projectList = value;
    notifyListeners();
  }

  void getProjectTree() {
    model.getProjectTree(canceler: httpCanceler).then((value) {
      if (value.success) {
        projectList = value.list!;
      }
    });
  }

  @override
  void onLifecycleChanged(LifecycleOwner owner, LifecycleState state) {
    if (state == LifecycleState.onInit) {
      httpCanceler = HttpCanceler(owner);
    } else if (state == LifecycleState.onCreate) {
      getProjectTree();
    }
  }
}
