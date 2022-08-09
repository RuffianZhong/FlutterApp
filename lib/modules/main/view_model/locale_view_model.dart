import 'package:flutter/material.dart';

import '../../../common/global_value.dart';

///本地化ViewModel
class LocaleViewModel extends ChangeNotifier {
  LocaleViewModel() {
    ///获取localIndex
    GlobalValue.getLocalIndex().then((value) {
      localIndex = value ?? 0;
    });
  }

  ///本地化列表
  final List<String> localList = ['zh', 'en'];

  ///本地化下标
  int _localIndex = 0;

  int get localIndex => _localIndex;

  set localIndex(int value) {
    _localIndex = value;
    notifyListeners();
  }

  ///local
  Locale get locale => Locale(localList[localIndex]);

  ///存储local
  void setLocalIndex(int index) {
    GlobalValue.setLocalIndex(index);
    localIndex = index;
  }
}
