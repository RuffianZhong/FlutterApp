import 'package:flutter/material.dart';
import 'package:flutter_lifecycle_aware/lifecycle_observer.dart';
import 'package:flutter_lifecycle_aware/lifecycle_owner.dart';
import 'package:flutter_lifecycle_aware/lifecycle_state.dart';
import 'package:flutter_wan_android/core/net/cancel/zt_http_cancel.dart';
import 'package:flutter_wan_android/modules/article/model/article_entity.dart';
import 'package:flutter_wan_android/modules/search/model/search_entity.dart';
import 'package:flutter_wan_android/modules/search/model/search_model.dart';

///SearchViewModel
class SearchViewModel extends ChangeNotifier with LifecycleObserver {
  late HttpCanceler httpCanceler;
  SearchModel model = SearchModel();

  ///编辑数据模式
  bool _editingData = false;

  bool get editingData => _editingData;

  set editingData(bool value) {
    _editingData = value;
    notifyListeners();
  }

  ///服务器标签
  List<SearchEntity>? _serverLabels = [];

  List<SearchEntity>? get serverLabels => _serverLabels;

  set serverLabels(List<SearchEntity>? value) {
    _serverLabels = value;
    notifyListeners();
  }

  void getHotKeyFromServer() async {
    model.getHotKeyFromServer().then((value) {
      if (value.success) {
        serverLabels = value.list;
      }
    });
  }

  ///本地标签
  List<SearchEntity>? _localLabels = [];

  List<SearchEntity>? get localLabels => _localLabels;

  set localLabels(List<SearchEntity>? value) {
    _localLabels = value;
    notifyListeners();
  }

  void getSearchKeyFromLocal() async {
    model.getLocalData().then((value) => localLabels = value);
  }

  ///展示搜索相关界面
  bool _showSearchUI = true;

  bool get showSearchUI => _showSearchUI;

  set showSearchUI(bool value) {
    _showSearchUI = value;
    notifyListeners();
  }

  ///文章列表
  List<ArticleEntity> _articleList = [];

  List<ArticleEntity> get articleList => _articleList;

  set articleList(List<ArticleEntity> value) {
    _articleList = value;
    notifyListeners();
  }

  ///搜索内容
  void getContentFromServer(String key) {
    model.getContentFromServer(key, httpCanceler).then((value) {
      if (value.success) {
        articleList = value.list!;
      }
    });
  }

  @override
  void onLifecycleChanged(LifecycleOwner owner, LifecycleState state) {
    if (state == LifecycleState.onInit) {
      httpCanceler = HttpCanceler(owner);
    } else if (state == LifecycleState.onCreate) {
      ///初始化本地数据
      getSearchKeyFromLocal();

      ///初始化服务器数据
      getHotKeyFromServer();
    } else if (state == LifecycleState.onDestroy) {
      model.close();
    }
  }
}
